import 'package:json_annotation/json_annotation.dart';

part 'location_selected.g.dart';

@JsonSerializable()
class LocationSelected {
  final String title;
  final double latitude, longitude;

  LocationSelected(this.title, this.latitude, this.longitude);

  @override
  String toString() {
    return 'LocationSelected{title: $title, latitude: $latitude, longitude: $longitude}';
  }

  factory LocationSelected.fromJson(Map<String, dynamic> json) =>
      _$LocationSelectedFromJson(json);

  Map<String, dynamic> toJson() => _$LocationSelectedToJson(this);
}
