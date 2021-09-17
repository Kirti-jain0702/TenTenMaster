// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addon_choices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddOnChoices _$AddOnChoicesFromJson(Map<String, dynamic> json) {
  return AddOnChoices(
    json['id'] as int,
    json['title'] as String,
    (json['price'] as num)?.toDouble(),
    json['product_addon_group_id'] as int,
    json['created_at'] as String,
    json['updated_at'] as String,
  )..selected = json['selected'] as bool;
}

Map<String, dynamic> _$AddOnChoicesToJson(AddOnChoices instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'product_addon_group_id': instance.productAddonGroupId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'selected': instance.selected,
    };
