import 'package:json_annotation/json_annotation.dart';

part 'order_addons.g.dart';

@JsonSerializable()
class OrderAddOns {
  final int choice_id;

  OrderAddOns(this.choice_id);

  factory OrderAddOns.fromJson(Map<String, dynamic> json) =>
      _$OrderAddOnsFromJson(json);

  Map<String, dynamic> toJson() => _$OrderAddOnsToJson(this);
}
