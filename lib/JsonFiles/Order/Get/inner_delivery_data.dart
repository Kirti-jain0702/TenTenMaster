import 'package:delivoo/JsonFiles/Auth/Responses/user_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inner_delivery_data.g.dart';

@JsonSerializable(anyMap: true)
class InnerDeliveryData {
  final int id;
  final meta;

  @JsonKey(name: 'is_verified')
  final int isVerified;
  @JsonKey(name: 'is_online')
  final int isOnline;
  final int assigned;
  final double longitude;
  final double latitude;
  final UserInformation user;

  InnerDeliveryData(
    this.id,
    this.meta,
    this.isVerified,
    this.isOnline,
    this.assigned,
    this.longitude,
    this.latitude,
    this.user,
  );

  factory InnerDeliveryData.fromJson(Map json) =>
      _$InnerDeliveryDataFromJson(json);

  Map toJson() => _$InnerDeliveryDataToJson(this);
}
