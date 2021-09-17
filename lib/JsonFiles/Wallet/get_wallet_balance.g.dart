// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_wallet_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletBalance _$WalletBalanceFromJson(Map<String, dynamic> json) {
  return WalletBalance(
    (json['balance'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$WalletBalanceToJson(WalletBalance instance) =>
    <String, dynamic>{
      'balance': instance.balance,
    };
