import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class Address {
  final int id;
  final String name;
  final String email;
  final String mobile;
  @JsonKey(name: 'formatted_address')
  final String formattedAddress;
  final String address1;
  final double longitude;
  final double latitude;
  @JsonKey(name: 'order_id')
  final int orderId;

  Address(this.id, this.name, this.email, this.mobile, this.formattedAddress,
      this.address1, this.longitude, this.latitude, this.orderId);

  factory Address.fromJson(Map json) => _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
