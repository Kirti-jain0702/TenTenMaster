import 'dart:convert';

import 'package:delivoo/Auth/AuthRepo/auth_interceptor.dart';
import 'package:delivoo/Cart/coupon.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CustomDeliveryBloc/custom_delivery_event.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CustomDeliveryBloc/custom_delivery_state.dart';
import 'package:delivoo/HomeOrderAccount/HomeRepository/home_client.dart';
import 'package:delivoo/JsonFiles/Address/getaddress_json.dart';
import 'package:delivoo/JsonFiles/CustomDelivery/custom_delivery.dart';
import 'package:delivoo/JsonFiles/CustomDelivery/delivery_fee.dart';
import 'package:delivoo/JsonFiles/CustomDelivery/order_meta.dart';
import 'package:delivoo/JsonFiles/Order/Get/order_data.dart';
import 'package:delivoo/JsonFiles/Products/product_data.dart';
import 'package:delivoo/JsonFiles/Vendors/vendor_data.dart';
import 'package:delivoo/JsonFiles/base_list_response.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRepository {
  final Dio dio;
  final HomeClient client;

  HomeRepository._(this.dio, this.client);

  factory HomeRepository() {
    Dio dio = Dio();
    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    HomeClient client = HomeClient(dio);
    dio.options.headers = {
      "content-type": "application/json",
      'Accept': 'application/json'
    };
    return HomeRepository._(dio, client);
  }

  Future<List<GetAddress>> getAddress() {
    return client.getAddresses();
  }

  Future<Coupon> verifyCoupon(String couponCode) {
    return client.checkCouponValidity(couponCode);
  }

  Future<List<Coupon>> getCoupons() {
    return client.getCoupons();
  }

  Future<GetAddress> addAddress(String title, String formattedAddress,
      double latitude, double longitude) {
    return client.addressAdd({
      "title": title,
      "formatted_address": formattedAddress,
      "latitude": latitude.toString(),
      "longitude": longitude.toString()
    });
  }

  Future<GetAddress> updateAddress(int addressId, String title,
      String formattedAddress, double latitude, double longitude) {
    return client.addressUpdate(addressId.toString(), {
      "title": title,
      "formatted_address": formattedAddress,
      "latitude": latitude.toString(),
      "longitude": longitude.toString()
    });
  }

  Future<BaseListResponse<Vendor>> searchVendors(
      String text, int catId, int pageNum, Position position) {
    return client.searchVendors(
        text, catId, position.latitude, position.longitude, pageNum);
  }

  Future<BaseListResponse<ProductData>> searchProducts(
      int vendorId, String text, int pageNum) {
    return vendorId == null
        ? client.searchProducts(text, pageNum)
        : client.searchProductsVendor(vendorId, text, pageNum);
  }

  Future<GetAddress> getSelectedAddress() async {
    var prefs = await SharedPreferences.getInstance();
    Map savedAddressMap = await prefs.containsKey("address_selected")
        ? (json.decode(prefs.getString("address_selected")))
        : null;
    return savedAddressMap != null
        ? GetAddress.fromJson(savedAddressMap)
        : null;
  }

  Future<bool> setSelectedAddress(GetAddress address) async {
    var prefs = await SharedPreferences.getInstance();
    return address == null
        ? prefs.remove("address_selected")
        : prefs.setString("address_selected", json.encode(address));
  }

  Future<void> deleteAddress(int id) {
    return client.deleteAddress(id);
  }

  Future<DeliveryFee> getDeliveryFee() {
    return client.getDeliveryFee();
  }

  Future<OrderData> createCustomOrder(
      CustomDeliveryState state, SubmittedEvent event) {
    CustomDelivery customDelivery = CustomDelivery(
        sourceContactName: event.sourceContactName,
        sourceContactNumber: event.sourceContactNumber,
        sourceFormattedAddress: state.pickupAddress,
        sourceAddress1: state.pickupAddress,
        sourceLatitude: state.pickupLatLng.latitude,
        sourceLongitude: state.pickupLatLng.longitude,
        destinationContactName: event.destinationContactName,
        destinationContactNumber: event.destinationContactNumber,
        destinationFormattedAddress: state.dropAddress,
        destinationAddress1: state.dropAddress,
        destinationLatitude: state.dropLatLng.latitude,
        destinationLongitude: state.dropLatLng.longitude,
        paymentMethodSlug: 'cod',
        notes: event.instruction,
        dynamicMeta: jsonEncode(OrderMeta(state.selectedValues).toJson()));
    return client.postCustomOrder(customDelivery);
  }
}
