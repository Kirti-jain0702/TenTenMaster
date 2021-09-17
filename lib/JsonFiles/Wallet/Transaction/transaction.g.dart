// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return Transaction(
    json['id'] as int,
    (json['amount'] as num)?.toDouble(),
    json['type'] as String,
    json['meta'],
    json['created_at'] as String,
    json['updated_at'] as String,
  )..createdAtFormatted = json['createdAtFormatted'] as String;
}

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'type': instance.type,
      'meta': instance.dynamicMeta,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'createdAtFormatted': instance.createdAtFormatted,
    };
