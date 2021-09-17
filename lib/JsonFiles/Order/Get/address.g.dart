// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map json) {
  return Address(
    json['id'] as int,
    json['name'] as String,
    json['email'] as String,
    json['mobile'] as String,
    json['formatted_address'] as String,
    json['address1'] as String,
    (json['longitude'] as num)?.toDouble(),
    (json['latitude'] as num)?.toDouble(),
    json['order_id'] as int,
  );
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'mobile': instance.mobile,
      'formatted_address': instance.formattedAddress,
      'address1': instance.address1,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'order_id': instance.orderId,
    };
