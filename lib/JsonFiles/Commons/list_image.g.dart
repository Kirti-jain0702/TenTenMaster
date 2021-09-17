// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListImage _$ListImageFromJson(Map json) {
  return ListImage(
    (json['images'] as List)
        ?.map((e) => e == null
            ? null
            : Image.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$ListImageToJson(ListImage instance) => <String, dynamic>{
      'images': instance.images?.map((e) => e?.toJson())?.toList(),
    };
