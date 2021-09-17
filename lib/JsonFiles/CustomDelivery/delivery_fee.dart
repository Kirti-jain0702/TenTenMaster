import 'package:json_annotation/json_annotation.dart';

part 'delivery_fee.g.dart';

@JsonSerializable()
class DeliveryFee {
  @JsonKey(name: 'delivery_fee')
  final String deliveryFee;

  DeliveryFee(this.deliveryFee);

  factory DeliveryFee.fromJson(Map json) => _$DeliveryFeeFromJson(json);

  Map toJson() => _$DeliveryFeeToJson(this);
}
