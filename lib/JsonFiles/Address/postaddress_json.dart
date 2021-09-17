import 'package:json_annotation/json_annotation.dart';

part 'postaddress_json.g.dart';

@JsonSerializable()
class PostAddress {
  final String title;
  @JsonKey(name: 'formatted_address')
  final String formattedAddress;
  final String address1;
  final double longitude;
  final double latitude;

  PostAddress(this.title, this.formattedAddress, this.address1, this.longitude,
      this.latitude);

  factory PostAddress.fromJson(Map<String, dynamic> json) =>
      _$PostAddressFromJson(json);

  Map<String, dynamic> toJson() => _$PostAddressToJson(this);
}
