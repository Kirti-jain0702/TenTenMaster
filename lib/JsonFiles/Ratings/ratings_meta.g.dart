// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ratings_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingsMeta _$RatingsMetaFromJson(Map<String, dynamic> json) {
  return RatingsMeta(
    json['current_page'] as int,
    json['from'] as int,
    json['last_page'] as int,
    json['path'] as String,
    json['per_page'] as int,
    json['to'] as int,
    json['total'] as int,
  );
}

Map<String, dynamic> _$RatingsMetaToJson(RatingsMeta instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'from': instance.from,
      'last_page': instance.lastPage,
      'path': instance.path,
      'per_page': instance.perPage,
      'to': instance.to,
      'total': instance.total,
    };
