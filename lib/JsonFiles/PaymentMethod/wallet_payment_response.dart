import 'package:json_annotation/json_annotation.dart';

part 'wallet_payment_response.g.dart';

@JsonSerializable()
class WalletPaymentResponse {
  final bool success;
  final String message;

  WalletPaymentResponse(this.success, this.message);

  factory WalletPaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletPaymentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WalletPaymentResponseToJson(this);
}
