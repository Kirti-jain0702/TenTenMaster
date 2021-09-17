// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseListResponse<T> _$BaseListResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object json) fromJsonT,
) {
  return BaseListResponse<T>(
    (json['data'] as List)?.map(fromJsonT)?.toList(),
    json['meta'] == null
        ? null
        : MetaList.fromJson(json['meta'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BaseListResponseToJson<T>(
  BaseListResponse<T> instance,
  Object Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': instance.data?.map(toJsonT)?.toList(),
      'meta': instance.meta,
    };
