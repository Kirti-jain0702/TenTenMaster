// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterUser _$RegisterUserFromJson(Map<String, dynamic> json) {
  return RegisterUser(
    name: json['name'] as String,
    email: json['email'] as String,
    role: json['role'] as String,
    mobileNumber: json['mobile_number'] as String,
  );
}

Map<String, dynamic> _$RegisterUserToJson(RegisterUser instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
      'mobile_number': instance.mobileNumber,
    };
