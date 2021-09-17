// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _ProductClient implements ProductClient {
  _ProductClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://admin.tentenecom.com/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<WalletPaymentResponse> payThroughStripe(id, stripeToken,
      [token]) async {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(stripeToken, 'stripeToken');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'token': stripeToken};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/payment/stripe/$id',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = WalletPaymentResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<Payment> depositWallet(map, [token]) async {
    ArgumentError.checkNotNull(map, 'map');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(map ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>(
        'api//user/wallet/deposit',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = Payment.fromJson(_result.data);
    return value;
  }

  @override
  Future<OrderData> getOrderById(orderId, [token]) async {
    ArgumentError.checkNotNull(orderId, 'orderId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/orders/$orderId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = OrderData.fromJson(_result.data);
    return value;
  }

  @override
  Future<ListCategories> getCategories() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/categories?parent=1&scope=ecommerce',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ListCategories.fromJson(_result.data);
    return value;
  }

  @override
  Future<BaseListResponse<Vendor>> getVendors(id, long, lat, page,
      [perPage = 15]) async {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(long, 'long');
    ArgumentError.checkNotNull(lat, 'lat');
    ArgumentError.checkNotNull(page, 'page');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'category': id,
      r'long': long,
      r'lat': lat,
      r'page': page,
      r'per_page': perPage
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('api/vendors/list',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = BaseListResponse<Vendor>.fromJson(
      _result.data,
      (json) => Vendor.fromJson(json),
    );
    return value;
  }

  @override
  Future<BaseListResponse<ProductData>> getProducts(
      vendorId, categoryId) async {
    ArgumentError.checkNotNull(vendorId, 'vendorId');
    ArgumentError.checkNotNull(categoryId, 'categoryId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'vendor': vendorId,
      r'category': categoryId
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('api/products',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = BaseListResponse<ProductData>.fromJson(
      _result.data,
      (json) => ProductData.fromJson(json),
    );
    return value;
  }

  @override
  Future<OrderData> postOrder(map, {double price, token}) async {
    ArgumentError.checkNotNull(map, 'map');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(map ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>('api/orders',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    print("trueValueTrue");

    final value = OrderData.fromJson(_result.data);
    value.payment.amount= price;
    print("trueValue >> $value");
    return value;
  }

  @override
  Future<WalletPaymentResponse> payThroughWallet(id, [token]) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/payment/wallet/$id',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = WalletPaymentResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethods([token]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('api/payment/methods',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => PaymentMethod.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<PaymentMethod>> getPrepaidPaymentMethods([token]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>(
        'api/payment/methods?type=prepaid',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => PaymentMethod.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<BaseListResponse<OrderData>> getOrdersNew(page, [token]) async {
    ArgumentError.checkNotNull(page, 'page');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'page': page};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/orders?active=1',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = BaseListResponse<OrderData>.fromJson(
      _result.data,
      (json) => OrderData.fromJson(json),
    );
    print("orders >> url >${_result.realUri} \ntoken >${token} \ndata>${_data} ");
    return value;
  }

  @override
  Future<BaseListResponse<OrderData>> getOrdersPast(page, [token]) async {
    ArgumentError.checkNotNull(page, 'page');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'page': page};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/orders?past=1',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = BaseListResponse<OrderData>.fromJson(
      _result.data,
      (json) => OrderData.fromJson(json),
    );
    return value;
  }

  @override
  Future<WalletBalance> getBalance([token]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/user/wallet/balance',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = WalletBalance.fromJson(_result.data);
    return value;
  }

  @override
  Future<WalletTransactions> getTransactions([token]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/user/wallet/transactions',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = WalletTransactions.fromJson(_result.data);
    return value;
  }

  @override
  Future<RatingsList> getVendorReviews(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/vendors/ratings/$id',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = RatingsList.fromJson(_result.data);
    return value;
  }

  @override
  Future<List<Setting>> getSettings() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('api/settings',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => Setting.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<void> postReview(vendorId, postRating, [token]) async {
    ArgumentError.checkNotNull(vendorId, 'vendorId');
    ArgumentError.checkNotNull(postRating, 'postRating');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(postRating?.toJson() ?? <String, dynamic>{});
    await _dio.request<void>('api/vendors/ratings/$vendorId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    return null;
  }
}
