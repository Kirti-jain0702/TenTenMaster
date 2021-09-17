import 'package:json_annotation/json_annotation.dart';

part 'addon_choices.g.dart';

@JsonSerializable()
class AddOnChoices {
  final int id;
  final String title;
  final double price;
  @JsonKey(name: 'product_addon_group_id')
  final int productAddonGroupId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  bool selected;

  AddOnChoices(this.id, this.title, this.price, this.productAddonGroupId,
      this.createdAt, this.updatedAt);

  factory AddOnChoices.fromJson(Map<String, dynamic> json) =>
      _$AddOnChoicesFromJson(json);

  Map<String, dynamic> toJson() => _$AddOnChoicesToJson(this);
}
