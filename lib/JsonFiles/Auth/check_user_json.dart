import 'package:json_annotation/json_annotation.dart';

///This allows the `CheckUser` class to access private members in the generated file.
part 'check_user_json.g.dart';

@JsonSerializable()
class CheckUser {
  @JsonKey(name: 'mobile_number')
  final String mobileNumber;

  CheckUser({this.mobileNumber});

  factory CheckUser.fromJson(Map<String, dynamic> json) =>
      _$CheckUserFromJson(json);

  Map<String, dynamic> toJson() => _$CheckUserToJson(this);
}
