import 'package:json_annotation/json_annotation.dart';

import 'order_addons.dart';

part 'order_product.g.dart';

@JsonSerializable()
class OrderProduct {
  final int id;
  final int quantity;
  final List<OrderAddOns> addons;

  OrderProduct(this.id, this.quantity, this.addons);

  factory OrderProduct.fromJson(Map<String, dynamic> json) =>
      _$OrderProductFromJson(json);

  Map<String, dynamic> toJson() => _$OrderProductToJson(this);
}
