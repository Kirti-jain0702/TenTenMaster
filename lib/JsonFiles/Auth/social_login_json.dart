import 'package:json_annotation/json_annotation.dart';

part 'social_login_json.g.dart';

@JsonSerializable()
class SocialLoginUser {
  final String token;
  final String platform;
  final String os;
  final String role;

  SocialLoginUser({this.token, this.platform, this.os, this.role});

  factory SocialLoginUser.fromJson(Map<String, dynamic> json) =>
      _$SocialLoginUserFromJson(json);

  Map<String, dynamic> toJson() => _$SocialLoginUserToJson(this);
}
