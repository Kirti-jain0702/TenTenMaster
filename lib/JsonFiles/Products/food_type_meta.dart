import 'package:json_annotation/json_annotation.dart';

part 'food_type_meta.g.dart';

@JsonSerializable(explicitToJson: true)
class FoodTypeMeta {
  @JsonKey(name: 'food_type')
  final String foodType;

  FoodTypeMeta(this.foodType);

  factory FoodTypeMeta.fromJson(Map<String, dynamic> json) =>
      _$FoodTypeMetaFromJson(json);

  Map<String, dynamic> toJson() => _$FoodTypeMetaToJson(this);
}
