// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_wallet_transactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletTransactions _$WalletTransactionsFromJson(Map<String, dynamic> json) {
  return WalletTransactions(
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : Transaction.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$WalletTransactionsToJson(WalletTransactions instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
