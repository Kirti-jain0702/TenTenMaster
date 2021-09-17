// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomLocation _$CustomLocationFromJson(Map json) {
  return CustomLocation(
    (json['latitude'] as num)?.toDouble(),
    (json['longitude'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$CustomLocationToJson(CustomLocation instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
