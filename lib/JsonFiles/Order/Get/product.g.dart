// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map json) {
  return Product(
    id: json['id']==null ?0.0: json['id'] as int,
    quantity: json['quantity']==null ?0.0: json['quantity'] as int,
    total: json['total']==null ?0.0:(json['total'] as num)?.toDouble(),
    subtotal:json['subtotal']==null ?0.0:  (json['subtotal'] as num)?.toDouble(),
    orderId: json['order_id']==null ?0:json['order_id'] as int,
    vendorProductId:json['vendor_product_id'] == null?0: json['vendor_product_id'] as int,
    vendorProduct: json['vendor_product'] == null
        ? null
        : VendorProduct.fromJson(json['vendor_product'] as Map),
    addonChoices: (json['addon_choices'] as List)
        ?.map((e) => e == null
            ? null
            : AddOnChoices.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'total': instance.total,
      'subtotal': instance.subtotal,
      'order_id': instance.orderId,
      'vendor_product_id': instance.vendorProductId,
      'vendor_product': instance.vendorProduct?.toJson(),
      'addon_choices': instance.addonChoices?.map((e) => e?.toJson())?.toList(),
    };
