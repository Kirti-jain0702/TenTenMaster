// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_register_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialRegisterUser _$SocialRegisterUserFromJson(Map<String, dynamic> json) {
  return SocialRegisterUser(
    name: json['name'] as String,
    email: json['email'] as String,
    role: json['role'] as String,
    mobileNumber: json['mobile_number'] as String,
    image: json['image'] as String,
  );
}

Map<String, dynamic> _$SocialRegisterUserToJson(SocialRegisterUser instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
      'mobile_number': instance.mobileNumber,
      'image': instance.image,
    };
