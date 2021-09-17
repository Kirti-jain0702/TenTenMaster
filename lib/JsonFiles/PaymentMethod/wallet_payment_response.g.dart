// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_payment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletPaymentResponse _$WalletPaymentResponseFromJson(
    Map<String, dynamic> json) {
  return WalletPaymentResponse(
    json['success'] as bool,
    json['message'] as String,
  );
}

Map<String, dynamic> _$WalletPaymentResponseToJson(
        WalletPaymentResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
    };
