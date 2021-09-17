import 'package:delivoo/JsonFiles/Auth/Responses/user_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final String token;

  @JsonKey(name: 'user')
  final UserInformation userInfo;

  LoginResponse({this.token, this.userInfo});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
