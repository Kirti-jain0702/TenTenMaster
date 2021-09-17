import 'package:delivoo/JsonFiles/Categories/category_data.dart';
import 'package:delivoo/JsonFiles/Commons/list_image.dart';
import 'package:delivoo/JsonFiles/Vendors/vendor_user_data.dart';
import 'package:json_annotation/json_annotation.dart';

import 'vendor_meta.dart';

part 'vendor_data.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class Vendor {
  final int id;
  final String name;
  final String tagline;
  final String details;
  final dynamic meta;

  @JsonKey(name: 'mediaurls')
  final dynamic dynamicMediaUrls;

  @JsonKey(name: 'minimum_order')
  final int minimumOrder;

  @JsonKey(name: 'delivery_fee')
  final double deliveryFee;
  final String area;
  final String address;
  final double longitude;
  final double latitude;

  @JsonKey(name: 'is_verified')
  final int isVerified;

  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;
  final List<CategoryData> categories;

  @JsonKey(name: 'product_categories')
  final List<CategoryData> productCategories;

  final VendorUserData user;
  final double ratings;
  @JsonKey(name: 'ratings_count')
  final int ratingsCount;
  @JsonKey(name: 'favourite_count')
  final int favouriteCount;
  @JsonKey(name: 'is_favourite')
  final bool isFavourite;

  final double distance;

  Vendor(
    this.id,
    this.name,
    this.tagline,
    this.details,
    this.meta,
    this.dynamicMediaUrls,
    this.minimumOrder,
    this.deliveryFee,
    this.area,
    this.address,
    this.longitude,
    this.latitude,
    this.isVerified,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.categories,
    this.user,
    this.ratings,
    this.ratingsCount,
    this.favouriteCount,
    this.isFavourite,
    this.productCategories,
    this.distance,
  );

  factory Vendor.fromJson(Map json) => _$VendorFromJson(json);

  Map toJson() => _$VendorToJson(this);

  VendorMeta getMeta() {
    return (meta != null && meta is Map) ? (VendorMeta.fromJson(meta)) : null;
  }

  ListImage get mediaUrls {
    return (dynamicMediaUrls != null && dynamicMediaUrls is Map)
        ? ListImage.fromJson(dynamicMediaUrls)
        : null;
  }
}
