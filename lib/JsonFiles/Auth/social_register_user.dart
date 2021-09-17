import 'package:json_annotation/json_annotation.dart';

part 'social_register_user.g.dart';

@JsonSerializable()
class SocialRegisterUser {
  final String name;
  final String email;
  final String role;

  @JsonKey(name: 'mobile_number')
  final String mobileNumber;
  final String image;

  SocialRegisterUser({
    this.name,
    this.email,
    this.role,
    this.mobileNumber,
    this.image,
  });

  factory SocialRegisterUser.fromJson(Map<String, dynamic> json) =>
      _$SocialRegisterUserFromJson(json);

  Map<String, dynamic> toJson() => _$SocialRegisterUserToJson(this);
}
