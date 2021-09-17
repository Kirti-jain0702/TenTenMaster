// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coupon _$CouponFromJson(Map<String, dynamic> json) {
  return Coupon(
    json['id'] as int,
    json['title'] as String,
    json['detail'] as String,
    json['code'] as String,
    json['type'] as String,
    json['expires_at'] as String,
    (json['reward'] as num)?.toDouble(),
    json['meta'],
  )..expiresAtFormatted = json['expiresAtFormatted'] as String;
}

Map<String, dynamic> _$CouponToJson(Coupon instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'detail': instance.detail,
      'code': instance.code,
      'type': instance.type,
      'expires_at': instance.expires_at,
      'reward': instance.reward,
      'meta': instance.meta,
      'expiresAtFormatted': instance.expiresAtFormatted,
    };
