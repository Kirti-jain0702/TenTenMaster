import 'package:delivoo/JsonFiles/Order/Get/inner_delivery_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delivery_data.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class DeliveryData {
  final int id;
  final String status;

  @JsonKey(name: 'orderId')
  final int orderId;

  final InnerDeliveryData delivery;

  DeliveryData(this.id, this.status, this.orderId, this.delivery);

  factory DeliveryData.fromJson(Map json) => _$DeliveryDataFromJson(json);

  Map toJson() => _$DeliveryDataToJson(this);
}
