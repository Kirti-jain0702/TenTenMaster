// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_categories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListCategories _$ListCategoriesFromJson(Map<String, dynamic> json) {
  return ListCategories(
    listOfData: (json['data'] as List)
        ?.map((e) =>
            e == null ? null : CategoryData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ListCategoriesToJson(ListCategories instance) =>
    <String, dynamic>{
      'data': instance.listOfData,
    };
