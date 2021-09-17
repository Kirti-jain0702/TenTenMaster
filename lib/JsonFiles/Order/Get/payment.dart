import 'package:delivoo/JsonFiles/PaymentMethod/payment_method.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class Payment {
  final int id;
  @JsonKey(name: 'payable_id')
  final int payableId;
  double amount;
  final String status;
  @JsonKey(name: 'payment_method')
  final PaymentMethod paymentMethod;

  Payment(
      this.id, this.payableId, this.amount, this.status, this.paymentMethod);

  factory Payment.fromJson(Map json) => _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
