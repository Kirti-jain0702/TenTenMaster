import 'package:delivoo/AppConfig/app_config.dart';
import 'package:delivoo/Constants/constants.dart';
import 'package:delivoo/JsonFiles/Categories/list_categories.dart';
import 'package:delivoo/JsonFiles/Order/Get/order_data.dart';
import 'package:delivoo/JsonFiles/Order/Get/payment.dart';
import 'package:delivoo/JsonFiles/PaymentMethod/payment_method.dart';
import 'package:delivoo/JsonFiles/PaymentMethod/wallet_payment_response.dart';
import 'package:delivoo/JsonFiles/Products/product_data.dart';
import 'package:delivoo/JsonFiles/Ratings/post_rating.dart';
import 'package:delivoo/JsonFiles/Ratings/ratings_list.dart';
import 'package:delivoo/JsonFiles/Vendors/vendor_data.dart';
import 'package:delivoo/JsonFiles/Wallet/Transaction/get_wallet_transactions.dart';
import 'package:delivoo/JsonFiles/Wallet/get_wallet_balance.dart';
import 'package:delivoo/JsonFiles/base_list_response.dart';
import 'package:delivoo/JsonFiles/settings.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'product_client.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class ProductClient {
  factory ProductClient(Dio dio, {String baseUrl}) = _ProductClient;

  @GET('api/payment/stripe/{id}')
  Future<WalletPaymentResponse> payThroughStripe(
      @Path('id') int id, @Query('token') String stripeToken,
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @POST('api//user/wallet/deposit')
  Future<Payment> depositWallet(@Body() Map<String, String> map,
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/orders/{id}')
  Future<OrderData> getOrderById(@Path('id') int orderId,
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/categories?parent=1')
  Future<ListCategories> getCategories();

  @GET('api/vendors/list')
  Future<BaseListResponse<Vendor>> getVendors(
    @Query('category') int id,
    @Query('long') double long,
    @Query('lat') double lat,
    @Query('page') int page, [
    @Query('per_page') int perPage = 15,
  ]);

  @GET('api/products')
  Future<BaseListResponse<ProductData>> getProducts(
      @Query('vendor') int vendorId, @Query('category') int categoryId);

  @POST('api/orders')
  Future<OrderData> postOrder(@Body() Map<String, dynamic> map,
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/payment/wallet/{id}')
  Future<WalletPaymentResponse> payThroughWallet(@Path('id') int id,
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/payment/methods')
  Future<List<PaymentMethod>> getPaymentMethods(
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/payment/methods?type=prepaid')
  Future<List<PaymentMethod>> getPrepaidPaymentMethods([
    @Header(HeaderKeys.authHeaderKey) String token,
  ]);

  @GET('api/orders?active=1')
  Future<BaseListResponse<OrderData>> getOrdersNew(@Query('page') int page,
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/orders?past=1')
  Future<BaseListResponse<OrderData>> getOrdersPast(@Query('page') int page,
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/user/wallet/balance')
  Future<WalletBalance> getBalance(
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/user/wallet/transactions')
  Future<WalletTransactions> getTransactions(
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/vendors/ratings/{id}')
  Future<RatingsList> getVendorReviews(@Path() int id);

  @GET('api/settings')
  Future<List<Setting>> getSettings();

  @POST('api/vendors/ratings/{id}')
  Future<void> postReview(
      @Path('id') int vendorId, @Body() PostRating postRating,
      [@Header(HeaderKeys.authHeaderKey) String token]);
}
