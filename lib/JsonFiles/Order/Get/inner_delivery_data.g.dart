// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inner_delivery_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InnerDeliveryData _$InnerDeliveryDataFromJson(Map json) {
  return InnerDeliveryData(
    json['id'] as int,
    json['meta'],
    json['is_verified'] as int,
    json['is_online'] as int,
    json['assigned'] as int,
    (json['longitude'] as num)?.toDouble(),
    (json['latitude'] as num)?.toDouble(),
    json['user'] == null ? null : UserInformation.fromJson(json['user'] as Map),
  );
}

Map<String, dynamic> _$InnerDeliveryDataToJson(InnerDeliveryData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'meta': instance.meta,
      'is_verified': instance.isVerified,
      'is_online': instance.isOnline,
      'assigned': instance.assigned,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'user': instance.user,
    };
