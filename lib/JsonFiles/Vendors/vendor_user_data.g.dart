// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorUserData _$VendorUserDataFromJson(Map<String, dynamic> json) {
  return VendorUserData(
    json['id'] as int,
    json['name'] as String,
    json['email'] as String,
    json['mobile_number'] as String,
    json['mobile_verified'] as int,
    json['active'] as int,
    json['language'] as String,
    json['notification'],
    json['remember_token'],
    json['created_at'] as String,
    json['updated_at'] as String,
  );
}

Map<String, dynamic> _$VendorUserDataToJson(VendorUserData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'mobile_number': instance.mobileNumber,
      'mobile_verified': instance.mobileVerified,
      'active': instance.active,
      'language': instance.language,
      'notification': instance.notification,
      'remember_token': instance.rememberToken,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
