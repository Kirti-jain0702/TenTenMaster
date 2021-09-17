// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrder _$CreateOrderFromJson(Map<String, dynamic> json) {
  return CreateOrder(
    json['address_id'] as int,
    json['payment_method_slug'] as String,
    (json['products'] as List)
        ?.map((e) =>
            e == null ? null : OrderProduct.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['type'] as String,
    json['scheduled_on'] as String,
    json['notes'] as String,
    json['coupon_code'] as String,
    json['order_type'] as String,
  );
}

Map<String, dynamic> _$CreateOrderToJson(CreateOrder instance) =>
    <String, dynamic>{
      'address_id': instance.address_id,
      'products': instance.products,
      'type': instance.type,
      'coupon_code': instance.coupon_code,
      'scheduled_on': instance.scheduled_on,
      'notes': instance.notes,
      'payment_method_slug': instance.payment_method_slug,
      'order_type': instance.order_type,
    };
