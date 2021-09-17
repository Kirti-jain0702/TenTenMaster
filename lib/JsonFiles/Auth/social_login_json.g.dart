// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_login_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialLoginUser _$SocialLoginUserFromJson(Map<String, dynamic> json) {
  return SocialLoginUser(
    token: json['token'] as String,
    platform: json['platform'] as String,
    os: json['os'] as String,
    role: json['role'] as String,
  );
}

Map<String, dynamic> _$SocialLoginUserToJson(SocialLoginUser instance) =>
    <String, dynamic>{
      'token': instance.token,
      'platform': instance.platform,
      'os': instance.os,
      'role': instance.role,
    };
