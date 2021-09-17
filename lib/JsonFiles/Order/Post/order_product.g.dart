// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderProduct _$OrderProductFromJson(Map<String, dynamic> json) {
  return OrderProduct(
    json['id'] as int,
    json['quantity'] as int,
    (json['addons'] as List)
        ?.map((e) =>
            e == null ? null : OrderAddOns.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$OrderProductToJson(OrderProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'addons': instance.addons,
    };
