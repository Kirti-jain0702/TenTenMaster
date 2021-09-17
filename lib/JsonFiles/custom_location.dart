import 'package:json_annotation/json_annotation.dart';

part 'custom_location.g.dart';

@JsonSerializable(anyMap: true)
class CustomLocation {
  final double latitude;
  final double longitude;

  CustomLocation(this.latitude, this.longitude);

  factory CustomLocation.fromJson(Map json) => _$CustomLocationFromJson(json);

  Map toJson() => _$CustomLocationToJson(this);
}
