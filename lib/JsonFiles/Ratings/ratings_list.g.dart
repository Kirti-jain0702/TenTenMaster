// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ratings_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingsList _$RatingsListFromJson(Map<String, dynamic> json) {
  return RatingsList(
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : RatingsData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$RatingsListToJson(RatingsList instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
