import 'package:delivoo/JsonFiles/Categories/category_data.dart';
import 'package:delivoo/JsonFiles/Commons/list_image.dart';
import 'package:delivoo/JsonFiles/Order/Post/order_addons.dart';
import 'package:delivoo/JsonFiles/Products/addon_choices.dart';
import 'package:delivoo/JsonFiles/Products/addon_groups.dart';
import 'package:delivoo/JsonFiles/Products/vendor_product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_data.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class ProductData {
  final int id;
  final String title;
  final String detail;
  final dynamic meta;
  final double price;
  final String owner;
  @JsonKey(name: 'parent_id')
  final int parentId;
  @JsonKey(name: 'attribute_term_id')
  final int attributeTermId;
  @JsonKey(name: 'mediaurls')
  final dynamic dynamicMediaUrls;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'addon_groups')
  final List<AddOnGroups> addOnGroups;
  final List<CategoryData> categories;
  @JsonKey(name: 'vendor_products')
  final List<VendorProduct> vendorProducts;
  final double ratings;

  @JsonKey(name: 'ratings_count')
  final int ratingsCount;

  @JsonKey(name: 'favourite_count')
  final int favouriteCount;

  @JsonKey(name: 'is_favourite')
  final bool isFavourite;

  @JsonKey(ignore: true)
  int quantity = 0;

  ProductData(
    this.id,
    this.title,
    this.detail,
    this.meta,
    this.price,
    this.owner,
    this.parentId,
    this.attributeTermId,
    this.createdAt,
    this.updatedAt,
    this.addOnGroups,
    this.categories,
    this.vendorProducts,
    this.dynamicMediaUrls,
    this.ratings,
    this.ratingsCount,
    this.favouriteCount,
    this.isFavourite,
  );

  factory ProductData.fromJson(Map json) => _$ProductDataFromJson(json);

  Map toJson() => _$ProductDataToJson(this);

  ListImage get mediaUrls {
    return (dynamicMediaUrls != null && dynamicMediaUrls is Map)
        ? ListImage.fromJson(dynamicMediaUrls)
        : null;
  }

  double getPriceWithAddOns() {
    double totalChoices = 0;
    if (addOnGroups != null &&
        addOnGroups.isNotEmpty &&
        addOnGroups.first.addOnChoices != null &&
        addOnGroups.first.addOnChoices.isNotEmpty) {
      for (AddOnChoices addOnChoice in addOnGroups.first.addOnChoices) {
        if (addOnChoice.selected == null) addOnChoice.selected = false;
        totalChoices += addOnChoice.selected ? addOnChoice.price : 0;
      }
    }
    return price + totalChoices;
  }

  double getPriceTotal() {
    return quantity * getPriceWithAddOns();
  }

  List<OrderAddOns> getChoiceIds() {
    List<OrderAddOns> toReturn = [];
    if (addOnGroups != null &&
        addOnGroups.isNotEmpty &&
        addOnGroups.first.addOnChoices != null &&
        addOnGroups.first.addOnChoices.isNotEmpty) {
      for (AddOnChoices addOnChoice in addOnGroups.first.addOnChoices) {
        if (addOnChoice.selected == null) addOnChoice.selected = false;
        if (addOnChoice.selected) toReturn.add(OrderAddOns(addOnChoice.id));
      }
    }
    return toReturn;
  }
}
