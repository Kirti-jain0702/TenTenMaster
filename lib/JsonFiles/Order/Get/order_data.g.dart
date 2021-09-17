// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderData _$OrderDataFromJson(Map json) {
  return OrderData(
    json['id'] as int,
    json['notes'] as String,
    json['meta'],
    (json['subtotal'] as num)?.toDouble(),
    (json['taxes'] as num)?.toDouble(),
    (json['delivery_fee'] as num)?.toDouble(),
    (json['total'] as num)?.toDouble(),
    (json['discount'] as num)?.toDouble(),
    json['type'] as String,
    json['scheduled_on'] as String,
    json['status'] as String,
    json['vendor_id'] as int,
    json['user_id'] as int,
    json['created_at'] as String,
    json['updated_at'] as String,
    (json['products'] as List)
        ?.map((e) => e == null ? null : Product.fromJson(e as Map))
        ?.toList(),
    json['vendor'] == null ? null : Vendor.fromJson(json['vendor'] as Map),
    json['user'] == null ? null : UserInformation.fromJson(json['user'] as Map),
    json['address'] == null ? null : Address.fromJson(json['address'] as Map),
    json['source_address'] == null
        ? null
        : Address.fromJson(json['source_address'] as Map),
    json['delivery'] == null
        ? null
        : DeliveryData.fromJson(json['delivery'] as Map),
    json['payment'] == null ? null : Payment.fromJson(json['payment'] as Map),
    json['order_type'] as String,
  )
    ..createdAtFormatted = json['createdAtFormatted'] as String
    ..scheduledOnFormatted = json['scheduledOnFormatted'] as String;
}

Map<String, dynamic> _$OrderDataToJson(OrderData instance) => <String, dynamic>{
      'id': instance.id,
      'notes': instance.notes,
      'meta': instance.dynamicMeta,
      'subtotal': instance.subtotal,
      'taxes': instance.taxes,
      'delivery_fee': instance.deliveryFee,
      'total': instance.total,
      'discount': instance.discount,
      'type': instance.type,
      'order_type': instance.orderType,
      'scheduled_on': instance.scheduledOn,
      'status': instance.status,
      'vendor_id': instance.vendorId,
      'user_id': instance.userId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'products': instance.products?.map((e) => e?.toJson())?.toList(),
      'vendor': instance.vendor?.toJson(),
      'user': instance.user?.toJson(),
      'address': instance.address?.toJson(),
      'source_address': instance.sourceAddress?.toJson(),
      'delivery': instance.delivery?.toJson(),
      'payment': instance.payment?.toJson(),
      'createdAtFormatted': instance.createdAtFormatted,
      'scheduledOnFormatted': instance.scheduledOnFormatted,
    };
