// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'links_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinksJson _$LinksJsonFromJson(Map<String, dynamic> json) {
  return LinksJson(
    json['first'] as String,
    json['last'] as String,
    json['prev'] as String,
    json['next'] as String,
  );
}

Map<String, dynamic> _$LinksJsonToJson(LinksJson instance) => <String, dynamic>{
      'first': instance.first,
      'last': instance.last,
      'prev': instance.prev,
      'next': instance.next,
    };
