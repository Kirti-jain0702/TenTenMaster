// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_selected.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationSelected _$LocationSelectedFromJson(Map<String, dynamic> json) {
  return LocationSelected(
    json['title'] as String,
    (json['latitude'] as num)?.toDouble(),
    (json['longitude'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$LocationSelectedToJson(LocationSelected instance) =>
    <String, dynamic>{
      'title': instance.title,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
