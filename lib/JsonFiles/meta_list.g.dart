// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaList _$MetaListFromJson(Map<String, dynamic> json) {
  return MetaList(
    json['current_page'] as int,
    json['from'] as int,
    json['last_page'] as int,
    json['path'] as String,
    json['per_page'] as int,
    json['to'] as int,
    json['total'] as int,
  );
}

Map<String, dynamic> _$MetaListToJson(MetaList instance) => <String, dynamic>{
      'current_page': instance.current_page,
      'from': instance.from,
      'last_page': instance.last_page,
      'path': instance.path,
      'per_page': instance.per_page,
      'to': instance.to,
      'total': instance.total,
    };
