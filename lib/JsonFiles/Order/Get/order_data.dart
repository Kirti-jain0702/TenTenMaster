import 'package:delivoo/JsonFiles/Auth/Responses/user_info.dart';
import 'package:delivoo/JsonFiles/CustomDelivery/order_meta.dart';
import 'package:delivoo/JsonFiles/Order/Get/address.dart';
import 'package:delivoo/JsonFiles/Order/Get/payment.dart';
import 'package:delivoo/JsonFiles/Order/Get/product.dart';
import 'package:delivoo/JsonFiles/Vendors/vendor_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:simple_moment/simple_moment.dart';

import 'delivery_data.dart';

part 'order_data.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class OrderData {
  final int id;
  final String notes;
  @JsonKey(name: 'meta')
  final dynamic dynamicMeta;
  final double subtotal;
  final double taxes;
  @JsonKey(name: 'delivery_fee')
  final double deliveryFee;
  final double total;
  final double discount;
  final String type;
  @JsonKey(name: 'order_type')
  final String orderType;
  @JsonKey(name: 'scheduled_on')
  final String scheduledOn;
  final String status;
  @JsonKey(name: 'vendor_id')
  final int vendorId;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  final List<Product> products;
  final Vendor vendor;
  final UserInformation user;
  final Address address;

  @JsonKey(name: 'source_address')
  final Address sourceAddress;
  final DeliveryData delivery;
  final Payment payment;

  String createdAtFormatted, scheduledOnFormatted;

  OrderData(
    this.id,
    this.notes,
    this.dynamicMeta,
    this.subtotal,
    this.taxes,
    this.deliveryFee,
    this.total,
    this.discount,
    this.type,
    this.scheduledOn,
    this.status,
    this.vendorId,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.products,
    this.vendor,
    this.user,
    this.address,
    this.sourceAddress,
    this.delivery,
    this.payment,
    this.orderType,
  );

  factory OrderData.fromJson(Map json) => _$OrderDataFromJson(json);

  Map toJson() => _$OrderDataToJson(this);

  setup() {
    Moment createdAtMoment = Moment.parse(createdAt);
    createdAtFormatted = createdAtMoment.format("dd MMM yyyy, HH:mm");
  }

  OrderMeta get meta {
    return (dynamicMeta != null && dynamicMeta is Map)
        ? OrderMeta.fromJson(dynamicMeta)
        : null;
  }
}
