// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryData _$CategoryDataFromJson(Map json) {
  return CategoryData(
    id: json['id'] as int,
    slug: json['slug'] as String,
    title: json['title'] as String,
    image_url: json['image_url'] as String,
    dynamicMediaUrls: json['mediaurls'],
    parentId: json['parent_id'] as int,
  );
}

Map<String, dynamic> _$CategoryDataToJson(CategoryData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'image_url': instance.image_url,
      'mediaurls': instance.dynamicMediaUrls,
      'parent_id': instance.parentId,
    };
