// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUserResponse _$UpdateUserResponseFromJson(Map<String, dynamic> json) {
  return UpdateUserResponse(
    json['data'] == null
        ? null
        : UserInformation.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UpdateUserResponseToJson(UpdateUserResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
