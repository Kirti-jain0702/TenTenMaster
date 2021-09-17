import 'package:json_annotation/json_annotation.dart';

part 'post_rating.g.dart';

@JsonSerializable()
class PostRating {
  final double rating;
  final String review;

  PostRating(this.rating, this.review);

  factory PostRating.fromJson(Map<String, dynamic> json) =>
      _$PostRatingFromJson(json);

  Map<String, dynamic> toJson() => _$PostRatingToJson(this);
}
