import 'package:delivoo/JsonFiles/Ratings/ratings_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ratings_list.g.dart';

@JsonSerializable()
class RatingsList {
  final List<RatingsData> data;

  RatingsList(this.data);

  factory RatingsList.fromJson(Map<String, dynamic> json) =>
      _$RatingsListFromJson(json);

  Map<String, dynamic> toJson() => _$RatingsListToJson(this);
}
