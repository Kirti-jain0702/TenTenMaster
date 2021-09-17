import 'package:delivoo/JsonFiles/Commons/list_image.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_data.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class CategoryData {
  final int id;
  final String slug;
  final String title;
  final String image_url;

  @JsonKey(name: 'mediaurls')
  final dynamic dynamicMediaUrls;

  @JsonKey(name: 'parent_id')
  final int parentId;

  CategoryData({
    this.id,
    this.slug,
    this.title,
    this.image_url,
    this.dynamicMediaUrls,
    this.parentId,
  });

  factory CategoryData.fromJson(Map json) => _$CategoryDataFromJson(json);

  Map toJson() => _$CategoryDataToJson(this);

  ListImage get mediaUrls {
    return (dynamicMediaUrls != null && dynamicMediaUrls is Map)
        ? ListImage.fromJson(dynamicMediaUrls)
        : null;
  }
}
