// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Setting _$SettingFromJson(Map<String, dynamic> json) {
  return Setting(
    json['id'] as int,
    json['key'] as String,
    json['value'] as String,
    json['type'] as String,
  );
}

Map<String, dynamic> _$SettingToJson(Setting instance) => <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'value': instance.value,
      'type': instance.type,
    };
