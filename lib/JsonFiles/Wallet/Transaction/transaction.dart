import 'package:delivoo/JsonFiles/Wallet/Transaction/transaction_meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:simple_moment/simple_moment.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
  final int id;
  final double amount;
  final String type;
  @JsonKey(name: 'meta')
  final dynamic dynamicMeta;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  String createdAtFormatted;

  Transaction(
    this.id,
    this.amount,
    this.type,
    this.dynamicMeta,
    this.createdAt,
    this.updatedAt,
  );
  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  setup() {
    Moment createdAtMoment = Moment.parse(createdAt);
    createdAtFormatted = createdAtMoment.format("dd MMM yyyy, HH:mm");
  }

  TransactionMeta get meta {
    return (dynamicMeta != null && dynamicMeta is Map)
        ? TransactionMeta.fromJson(dynamicMeta)
        : null;
  }
}
