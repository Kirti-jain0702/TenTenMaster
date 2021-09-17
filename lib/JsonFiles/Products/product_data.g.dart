// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductData _$ProductDataFromJson(Map json) {
  var addOnGroups= (json['addon_groups'] as List)
      ?.map((e) => e == null
      ? null
      : AddOnGroups.fromJson((e as Map)?.map(
        (k, e) => MapEntry(k as String, e),
  )))
      ?.toList();
/*  var sd=addOnGroups;
  print("matcha goes >> ${sd[0].addOnChoices[0].title}");*/
  return ProductData(
    json['id'] as int,
    json['title'] as String,
    json['detail'] as String,
    json['meta'],
    addOnGroups!=null&&addOnGroups.length>0?addOnGroups[0].addOnChoices[0].price.toDouble():(json['price'] as num)?.toDouble(),
    json['owner'] as String,
    json['parent_id'] as int,
    json['attribute_term_id'] as int,
    json['created_at'] as String,
    json['updated_at'] as String,
    addOnGroups ,
    //addOnGroups[0].addOnChoices[0].title,
    (json['categories'] as List)
        ?.map((e) => e == null ? null : CategoryData.fromJson(e as Map))
        ?.toList(),
    (json['vendor_products'] as List)
        ?.map((e) => e == null ? null : VendorProduct.fromJson(e as Map))
        ?.toList(),

    json['mediaurls'],
    (json['ratings'] as num)?.toDouble(),
    json['ratings_count'] as int,
    json['favourite_count'] as int,
    json['is_favourite'] as bool,
  );
}

Map<String, dynamic> _$ProductDataToJson(ProductData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'detail': instance.detail,
      'meta': instance.meta,
      'price': instance.price,
      'owner': instance.owner,
      'parent_id': instance.parentId,
      'attribute_term_id': instance.attributeTermId,
      'mediaurls': instance.dynamicMediaUrls,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'addon_groups': instance.addOnGroups?.map((e) => e?.toJson())?.toList(),
      'categories': instance.categories?.map((e) => e?.toJson())?.toList(),
      'vendor_products':
          instance.vendorProducts?.map((e) => e?.toJson())?.toList(),
      'ratings': instance.ratings,
      'ratings_count': instance.ratingsCount,
      'favourite_count': instance.favouriteCount,
      'is_favourite': instance.isFavourite,
    };
