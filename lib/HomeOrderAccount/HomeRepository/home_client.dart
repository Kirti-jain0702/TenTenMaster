import 'package:delivoo/AppConfig/app_config.dart';
import 'package:delivoo/Cart/coupon.dart';
import 'package:delivoo/Constants/constants.dart';
import 'package:delivoo/JsonFiles/Address/getaddress_json.dart';
import 'package:delivoo/JsonFiles/Banner/Banner.dart';
import 'package:delivoo/JsonFiles/CustomDelivery/custom_delivery.dart';
import 'package:delivoo/JsonFiles/CustomDelivery/delivery_fee.dart';
import 'package:delivoo/JsonFiles/Order/Get/order_data.dart';
import 'package:delivoo/JsonFiles/Products/product_data.dart';
import 'package:delivoo/JsonFiles/Vendors/vendor_data.dart';
import 'package:delivoo/JsonFiles/base_list_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'home_client.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class HomeClient {
  factory HomeClient(Dio dio, {String baseUrl}) = _HomeClient;


  @GET('api/banners')
  Future<BannerData> getBanners();


  @GET('api/addresses')
  Future<List<GetAddress>> getAddresses(
      [@Header(Constants.authHeaderKey) String token]);

  @POST('api/addresses')
  Future<GetAddress> addressAdd(@Body() Map<String, String> map,
      [@Header(Constants.authHeaderKey) String token]);

  @PUT('api/addresses/{addressId}')
  Future<GetAddress> addressUpdate(
      @Path() String addressId, @Body() Map<String, String> map,
      [@Header(Constants.authHeaderKey) String token]);

  @GET('api/vendors/list')
  Future<BaseListResponse<Vendor>> searchVendors(@Query('search') String text,
      [@Query('category') int catId,
      @Query('lat') double lat,
      @Query('long') double lng,
      @Query('page') int pageNum]);

  @GET('api/products')
  Future<BaseListResponse<ProductData>> searchProducts(
      @Query('search') String text, @Query('page') int pageNum);

  @GET('api/products')
  Future<BaseListResponse<ProductData>> searchProductsVendor(
      @Query('vendor') int vendorId,
      @Query('search') String text,
      @Query('page') int pageNum);

  @GET('api/orders/calculate-delivery-fee?order_type=CUSTOM')
  Future<DeliveryFee> getDeliveryFee(
      [@Header(Constants.authHeaderKey) String token]);

  @POST('api/orders')
  Future<OrderData> postCustomOrder(@Body() CustomDelivery customDelivery,
      [@Header(Constants.authHeaderKey) String token]);

  @DELETE('api/addresses/{addressId}')
  Future<OrderData> deleteAddress(@Path('addressId') int id,
      [@Header(Constants.authHeaderKey) String token]);

  @GET('api/coupons')
  Future<List<Coupon>> getCoupons(
      [@Header(Constants.authHeaderKey) String token]);

  @GET('api/coupons/check-validity')
  Future<Coupon> checkCouponValidity(@Query('code') String couponCode,
      [@Header(Constants.authHeaderKey) String token]);
}
