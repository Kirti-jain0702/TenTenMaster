// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addon_groups.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddOnGroups _$AddOnGroupsFromJson(Map<String, dynamic> json) {
  return AddOnGroups(
    json['id'] as int,
    json['title'] as String,
    json['max_choices'] as int,
    json['min_choices'] as int,
    json['product_id'] as int,
    (json['addon_choices'] as List)
        ?.map((e) =>
            e == null ? null : AddOnChoices.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AddOnGroupsToJson(AddOnGroups instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'max_choices': instance.maxChoices,
      'min_choices': instance.minChoices,
      'product_id': instance.productId,
      'addon_choices': instance.addOnChoices?.map((e) => e?.toJson())?.toList(),
    };
