// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Support _$SupportFromJson(Map<String, dynamic> json) {
  return Support(
    name: json['name'] as String,
    email: json['email'] as String,
    message: json['message'] as String,
  );
}

Map<String, dynamic> _$SupportToJson(Support instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'message': instance.message,
    };
