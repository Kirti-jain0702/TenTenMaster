// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryData _$DeliveryDataFromJson(Map json) {
  return DeliveryData(
    json['id'] as int,
    json['status'] as String,
    json['orderId'] as int,
    json['delivery'] == null
        ? null
        : InnerDeliveryData.fromJson(json['delivery'] as Map),
  );
}

Map<String, dynamic> _$DeliveryDataToJson(DeliveryData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'orderId': instance.orderId,
      'delivery': instance.delivery?.toJson(),
    };
