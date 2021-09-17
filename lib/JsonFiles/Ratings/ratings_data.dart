import 'package:delivoo/JsonFiles/Auth/Responses/user_info.dart';
import 'package:delivoo/JsonFiles/Vendors/vendor_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ratings_data.g.dart';

@JsonSerializable()
class RatingsData {
  final int id;
  final int rating;
  final String review;

  @JsonKey(name: 'created_at')
  final String createdAt;
  final UserInformation user;
  final Vendor vendor;

  RatingsData(this.id, this.rating, this.review, this.createdAt, this.user,
      this.vendor);

  factory RatingsData.fromJson(Map<String, dynamic> json) =>
      _$RatingsDataFromJson(json);

  Map<String, dynamic> toJson() => _$RatingsDataToJson(this);
}
