import 'package:delivoo/JsonFiles/Products/product_data.dart';
import 'package:delivoo/JsonFiles/Vendors/vendor_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vendor_product.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class VendorProduct {
  final int id;
  final double price;
  @JsonKey(name: 'sale_price')
  final double salePrice;
  @JsonKey(name: 'sale_price_from')
  final double salePriceFrom;
  @JsonKey(name: 'sale_price_to')
  final double salePriceTo;
  @JsonKey(name: 'stock_quantity')
  final int stockQuantity;
  @JsonKey(name: 'stock_low_threshold')
  final int stockLowThreshold;
  @JsonKey(name: 'product_id')
  final int productId;
  @JsonKey(name: 'vendor_id')
  final int vendorId;
  final Vendor vendor;

  final ProductData product;
  @JsonKey(name: 'sells_count')
  final int sellsCount;

  VendorProduct(
  { this.id,
      this.price,
      this.salePrice,
      this.salePriceFrom,
      this.salePriceTo,
      this.stockQuantity,
      this.stockLowThreshold,
      this.productId,
      this.vendorId,
      this.vendor,
      this.sellsCount,
      this.product}
      );

  factory VendorProduct.fromJson(Map json) => _$VendorProductFromJson(json);

  Map toJson() => _$VendorProductToJson(this);
}
