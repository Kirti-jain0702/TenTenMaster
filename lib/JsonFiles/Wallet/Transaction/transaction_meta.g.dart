// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionMeta _$TransactionMetaFromJson(Map<String, dynamic> json) {
  return TransactionMeta(
    json['type'] as String,
    json['bank_code'] as String,
    json['bank_name'] as String,
    json['description'] as String,
    json['bank_account_name'] as String,
    json['bank_account_number'] as String,
  );
}

Map<String, dynamic> _$TransactionMetaToJson(TransactionMeta instance) =>
    <String, dynamic>{
      'type': instance.type,
      'bank_code': instance.bankCode,
      'bank_name': instance.bankName,
      'description': instance.description,
      'bank_account_name': instance.bankAccountName,
      'bank_account_number': instance.bankAccountNumber,
    };
