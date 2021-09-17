// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostRating _$PostRatingFromJson(Map<String, dynamic> json) {
  return PostRating(
    (json['rating'] as num)?.toDouble(),
    json['review'] as String,
  );
}

Map<String, dynamic> _$PostRatingToJson(PostRating instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'review': instance.review,
    };
