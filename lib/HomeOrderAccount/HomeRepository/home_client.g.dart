// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _HomeClient implements HomeClient {
  _HomeClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://admin.tentenecom.com/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<List<GetAddress>> getAddresses([token]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('api/addresses',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => GetAddress.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<GetAddress> addressAdd(map, [token]) async {
    ArgumentError.checkNotNull(map, 'map');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(map ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>('api/addresses',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = GetAddress.fromJson(_result.data);
    return value;
  }

  @override
  Future<GetAddress> addressUpdate(addressId, map, [token]) async {
    ArgumentError.checkNotNull(addressId, 'addressId');
    ArgumentError.checkNotNull(map, 'map');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(map ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/addresses/$addressId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'PUT',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = GetAddress.fromJson(_result.data);
    return value;
  }

  @override
  Future<BaseListResponse<Vendor>> searchVendors(text,
      [catId, lat, lng, pageNum]) async {
    ArgumentError.checkNotNull(text, 'text');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'search': text,
      r'category': catId,
      r'lat': lat,
      r'long': lng,
      r'page': pageNum
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
  Future<BaseListResponse<ProductData>> searchProducts(text, pageNum) async {
    ArgumentError.checkNotNull(text, 'text');
    ArgumentError.checkNotNull(pageNum, 'pageNum');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'search': text,
      r'page': pageNum
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
  Future<BaseListResponse<ProductData>> searchProductsVendor(
      vendorId, text, pageNum) async {
    ArgumentError.checkNotNull(vendorId, 'vendorId');
    ArgumentError.checkNotNull(text, 'text');
    ArgumentError.checkNotNull(pageNum, 'pageNum');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'vendor': vendorId,
      r'search': text,
      r'page': pageNum
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
  Future<DeliveryFee> getDeliveryFee([token]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/orders/calculate-delivery-fee?order_type=CUSTOM',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = DeliveryFee.fromJson(_result.data);
    return value;
  }

  @override
  Future<OrderData> postCustomOrder(customDelivery, [token]) async {
    ArgumentError.checkNotNull(customDelivery, 'customDelivery');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(customDelivery?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>('api/orders',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = OrderData.fromJson(_result.data);
    return value;
  }

  @override
  Future<OrderData> deleteAddress(id, [token]) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/addresses/$id',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'DELETE',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = OrderData.fromJson(_result.data);
    return value;
  }

  @override
  Future<List<Coupon>> getCoupons([token]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('api/coupons',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => Coupon.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<Coupon> checkCouponValidity(couponCode, [token]) async {
    ArgumentError.checkNotNull(couponCode, 'couponCode');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'code': couponCode};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/coupons/check-validity',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = Coupon.fromJson(_result.data);
    return value;
  }


  @override
  Future<BannerData> getBanners() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'api/banners',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = BannerData.fromJson(_result.data);
    return value;
  }

}
