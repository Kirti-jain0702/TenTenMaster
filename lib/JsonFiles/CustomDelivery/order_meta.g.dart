// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderMeta _$OrderMetaFromJson(Map json) {
  return OrderMeta(
    (json['packageTypes'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$OrderMetaToJson(OrderMeta instance) => <String, dynamic>{
      'packageTypes': instance.packageTypes,
    };
