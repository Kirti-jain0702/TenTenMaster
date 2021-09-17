import 'package:delivoo/JsonFiles/Products/addon_choices.dart';
import 'package:delivoo/JsonFiles/Products/vendor_product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class Product {
  final int id;
  final int quantity;
  final double total;
  final double subtotal;
  @JsonKey(name: 'order_id')
  final int orderId;
  @JsonKey(name: 'vendor_product_id')
  final int vendorProductId;
  @JsonKey(name: 'vendor_product')
  final VendorProduct vendorProduct;
  @JsonKey(name: 'addon_choices')
  final List<AddOnChoices> addonChoices;

  Product({
    this.id,
    this.quantity,
    this.total,
    this.subtotal,
    this.orderId,
    this.vendorProductId,
    this.vendorProduct,
    this.addonChoices,
  });

  factory Product.fromJson(Map json) => _$ProductFromJson(json);

  Map toJson() => _$ProductToJson(this);
}
