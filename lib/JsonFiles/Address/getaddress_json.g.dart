// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getaddress_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAddress _$GetAddressFromJson(Map<String, dynamic> json) {
  return GetAddress(
    json['id'] as int,
    json['title'] as String,
    json['meta'],
    json['formatted_address'] as String,
    json['address1'] as String,
    json['address2'],
    json['country'],
    json['state'],
    json['city'],
    json['postcode'],
    (json['longitude'] as num)?.toDouble(),
    (json['latitude'] as num)?.toDouble(),
    json['user_id'] as int,
  );
}

Map<String, dynamic> _$GetAddressToJson(GetAddress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'meta': instance.meta,
      'formatted_address': instance.formattedAddress,
      'address1': instance.address1,
      'address2': instance.address2,
      'country': instance.country,
      'state': instance.state,
      'city': instance.city,
      'postcode': instance.postcode,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'user_id': instance.userId,
    };
