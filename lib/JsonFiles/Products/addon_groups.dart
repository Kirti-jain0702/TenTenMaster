import 'package:delivoo/JsonFiles/Products/addon_choices.dart';
import 'package:json_annotation/json_annotation.dart';

part 'addon_groups.g.dart';

@JsonSerializable(explicitToJson: true)
class AddOnGroups {
  final int id;
  final String title;
  @JsonKey(name: 'max_choices')
  final int maxChoices;
  @JsonKey(name: 'min_choices')
  final int minChoices;
  @JsonKey(name: 'product_id')
  final int productId;
  @JsonKey(name: 'addon_choices')
  final List<AddOnChoices> addOnChoices;

  AddOnGroups(this.id, this.title, this.maxChoices, this.minChoices,
      this.productId, this.addOnChoices);

  factory AddOnGroups.fromJson(Map<String, dynamic> json) =>
      _$AddOnGroupsFromJson(json);

  Map<String, dynamic> toJson() => _$AddOnGroupsToJson(this);
}
