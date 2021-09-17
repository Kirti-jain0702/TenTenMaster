import 'package:json_annotation/json_annotation.dart';

///This allows the `VerifyMobile` class to access private members in the generated file.
part 'verify_mobile_json.g.dart';

@JsonSerializable()
class VerifyMobile {
  @JsonKey(name: 'mobile_number')
  final String mobileNumber;

  VerifyMobile({this.mobileNumber});

  factory VerifyMobile.fromJson(Map<String, dynamic> json) =>
      _$VerifyMobileFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyMobileToJson(this);
}
