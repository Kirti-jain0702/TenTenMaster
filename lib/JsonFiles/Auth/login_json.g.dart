// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Login _$LoginFromJson(Map<String, dynamic> json) {
  return Login(
    token: json['token'] as String,
    role: json['role'] as String,
  );
}

Map<String, dynamic> _$LoginToJson(Login instance) => <String, dynamic>{
      'token': instance.token,
      'role': instance.role,
    };
