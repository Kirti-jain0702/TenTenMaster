// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorProduct _$VendorProductFromJson(Map json) {
  return VendorProduct(
    id: json['id'] as int,
    price: (json['price'] as num)?.toDouble(),
    salePrice: json['sale_price'] == null
        ? 0.0
        : (json['sale_price'] as num)?.toDouble(),
    salePriceFrom: json['sale_price_from'] == null
        ? 0.0
        : (json['sale_price_from'] as num)?.toDouble(),
    salePriceTo: json['sale_price_to'] == null
        ? 0.0
        : (json['sale_price_to'] as num)?.toDouble(),
    stockQuantity: json['stock_quantity'] as int,
    stockLowThreshold: json['stock_low_threshold'] as int,
    productId: json['product_id'] as int,
    vendorId: json['vendor_id'] as int,
    vendor:
        json['vendor'] == null ? null : Vendor.fromJson(json['vendor'] as Map),
    sellsCount: json['sells_count'] as int,
    product: json['product'] == null
        ? null
        : ProductData.fromJson(json['product'] as Map),
  );
}

Map<String, dynamic> _$VendorProductToJson(VendorProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'sale_price': instance.salePrice,
      'sale_price_from': instance.salePriceFrom,
      'sale_price_to': instance.salePriceTo,
      'stock_quantity': instance.stockQuantity,
      'stock_low_threshold': instance.stockLowThreshold,
      'product_id': instance.productId,
      'vendor_id': instance.vendorId,
      'vendor': instance.vendor?.toJson(),
      'product': instance.product?.toJson(),
      'sells_count': instance.sellsCount,
    };
