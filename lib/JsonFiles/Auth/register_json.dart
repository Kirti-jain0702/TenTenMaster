import 'package:json_annotation/json_annotation.dart';

part 'register_json.g.dart';

@JsonSerializable()
class RegisterUser {
  final String name;
  final String email;
  final String role;

  @JsonKey(name: 'mobile_number')
  final String mobileNumber;

  RegisterUser({this.name, this.email, this.role, this.mobileNumber});

  factory RegisterUser.fromJson(Map<String, dynamic> json) =>
      _$RegisterUserFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterUserToJson(this);
}
