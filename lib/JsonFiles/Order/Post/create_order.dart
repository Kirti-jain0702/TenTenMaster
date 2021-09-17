import 'package:json_annotation/json_annotation.dart';

import 'order_product.dart';

part 'create_order.g.dart';

@JsonSerializable()
class CreateOrder {
  final int address_id;
  final List<OrderProduct> products;
  final String type,
      coupon_code,
      scheduled_on,
      notes,
      payment_method_slug,
      order_type;

  CreateOrder(
      this.address_id,
      this.payment_method_slug,
      this.products,
      this.type,
      this.scheduled_on,
      this.notes,
      this.coupon_code,
      this.order_type);

  factory CreateOrder.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderToJson(this);
}
