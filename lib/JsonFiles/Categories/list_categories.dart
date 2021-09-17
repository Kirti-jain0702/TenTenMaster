import 'package:json_annotation/json_annotation.dart';

import 'category_data.dart';

part 'list_categories.g.dart';

@JsonSerializable()
class ListCategories {
  @JsonKey(name: 'data')
  final List<CategoryData> listOfData;

  ListCategories({this.listOfData});

  factory ListCategories.fromJson(Map<String, dynamic> json) =>
      _$ListCategoriesFromJson(json);

  Map<String, dynamic> toJson() => _$ListCategoriesToJson(this);
}
