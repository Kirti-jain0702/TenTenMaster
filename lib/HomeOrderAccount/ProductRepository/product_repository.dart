import 'package:delivoo/Auth/AuthRepo/auth_interceptor.dart';
import 'package:delivoo/HomeOrderAccount/ProductRepository/product_client.dart';
import 'package:delivoo/JsonFiles/Categories/list_categories.dart';
import 'package:delivoo/JsonFiles/Order/Get/order_data.dart';
import 'package:delivoo/JsonFiles/Order/Get/payment.dart';
import 'package:delivoo/JsonFiles/Order/Post/create_order.dart';
import 'package:delivoo/JsonFiles/PaymentMethod/payment_method.dart';
import 'package:delivoo/JsonFiles/PaymentMethod/wallet_payment_response.dart';
import 'package:delivoo/JsonFiles/Products/product_data.dart';
import 'package:delivoo/JsonFiles/Ratings/post_rating.dart';
import 'package:delivoo/JsonFiles/Ratings/ratings_list.dart';
import 'package:delivoo/JsonFiles/Vendors/vendor_data.dart';
import 'package:delivoo/JsonFiles/base_list_response.dart';
import 'package:delivoo/JsonFiles/settings.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../JsonFiles/Wallet/Transaction/get_wallet_transactions.dart';
import '../../JsonFiles/Wallet/get_wallet_balance.dart';

class ProductRepository {
  final Dio dio;
  final ProductClient client;

  ProductRepository._(this.dio, this.client);

  factory ProductRepository() {
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
    ProductClient client = ProductClient(dio);
    dio.options.headers = {
      "content-type": "application/json",
      'Accept': 'application/json'
    };
    return ProductRepository._(dio, client);
  }

  DatabaseReference _firebaseDbRef = FirebaseDatabase.instance.reference();

  Future<OrderData> getOrderById(int orderId) async {
    return client.getOrderById(orderId);
  }

  Future<ListCategories> listOfCategories() async {
    return client.getCategories();
  }

  Future<BaseListResponse<Vendor>> listOfVendors(
      int id, double latitude, double longitude, int page) {
    return client.getVendors(id, longitude, latitude, page);
  }

  Future<BaseListResponse<ProductData>> listOfProducts(
      int vendorId, int categoryId) {
    return client.getProducts(vendorId, categoryId);
  }

  Future<OrderData> postOrder(CreateOrder createOrderRequest) async {
    Map<String, dynamic> cor = createOrderRequest.toJson();
    cor.removeWhere((key, value) => value == null);
    return client.postOrder(cor);
  }

  Future<WalletPaymentResponse> payThroughWallet(int id) async {
    return client.payThroughWallet(id);
  }

  Future<WalletPaymentResponse> payThroughStripe(
      int paymentId, String stripeToken) async {
    return client.payThroughStripe(paymentId, stripeToken);
  }

  Future<Payment> depositWallet(String amount, String paymentMethodSlug) {
    return client.depositWallet(
        {"amount": amount, "payment_method_slug": paymentMethodSlug});
  }

  Future<List<PaymentMethod>> getPaymentMethod() async {
    return client.getPaymentMethods();
  }

  Future<List<PaymentMethod>> getPrepaidPaymentMethod() async {
    return client.getPrepaidPaymentMethods();
  }

  Future<BaseListResponse<OrderData>> getOrdersNew(int pageNum) {
    return client.getOrdersNew(pageNum);
  }

  Future<BaseListResponse<OrderData>> getOrdersPast(int pageNum) {
    return client.getOrdersPast(pageNum);
  }

  Stream<Event> getOrdersFirebaseDbRef(int userId) async* {
    print("getOrdersFirebaseDbRef: $userId");
    yield* _firebaseDbRef.child('users/$userId/orders').onChildChanged;
  }

  Stream<Event> getOrderFirebaseDbRef(int userId, int orderId) {
    print("getOrderFirebaseDbRef: $userId, $orderId");
    return _firebaseDbRef.child('users/$userId/orders/$orderId/data').onValue;
  }

  Future<List<Setting>> getSettings() {
    return client.getSettings();
  }

  Future<WalletBalance> getBalance() {
    return client.getBalance();
  }

  Future<WalletTransactions> getTransactions() {
    return client.getTransactions();
  }

  Future<RatingsList> getVendorReviews(int id) {
    return client.getVendorReviews(id);
  }

  Future<void> postReview(int id, PostRating postRating) {
    return client.postReview(id, postRating);
  }
}
