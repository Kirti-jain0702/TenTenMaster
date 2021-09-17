// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vendor _$VendorFromJson(Map json) {
  return Vendor(
    json['id'] as int,
    json['name'] as String,
    json['tagline'] as String,
    json['details'] as String,
    json['meta'],
    json['mediaurls'],
    json['minimum_order'] as int,
    (json['delivery_fee'] as num)?.toDouble(),
    json['area'] as String,
    json['address'] as String,
    (json['longitude'] as num)?.toDouble(),
    (json['latitude'] as num)?.toDouble(),
    json['is_verified'] as int,
    json['user_id'] as int,
    json['created_at'] as String,
    json['updated_at'] as String,
    (json['categories'] as List)
        ?.map((e) => e == null ? null : CategoryData.fromJson(e as Map))
        ?.toList(),
    json['user'] == null
        ? null
        : VendorUserData.fromJson((json['user'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    (json['ratings'] as num)?.toDouble(),
    json['ratings_count'] as int,
    json['favourite_count'] as int,
    json['is_favourite'] as bool,
    (json['product_categories'] as List)
        ?.map((e) => e == null ? null : CategoryData.fromJson(e as Map))
        ?.toList(),
    (json['distance'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$VendorToJson(Vendor instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tagline': instance.tagline,
      'details': instance.details,
      'meta': instance.meta,
      'mediaurls': instance.dynamicMediaUrls,
      'minimum_order': instance.minimumOrder,
      'delivery_fee': instance.deliveryFee,
      'area': instance.area,
      'address': instance.address,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'is_verified': instance.isVerified,
      'user_id': instance.userId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'categories': instance.categories?.map((e) => e?.toJson())?.toList(),
      'product_categories':
          instance.productCategories?.map((e) => e?.toJson())?.toList(),
      'user': instance.user?.toJson(),
      'ratings': instance.ratings,
      'ratings_count': instance.ratingsCount,
      'favourite_count': instance.favouriteCount,
      'is_favourite': instance.isFavourite,
      'distance': instance.distance,
    };
