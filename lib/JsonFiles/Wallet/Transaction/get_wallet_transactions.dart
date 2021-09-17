import 'package:delivoo/JsonFiles/Wallet/Transaction/transaction.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_wallet_transactions.g.dart';

@JsonSerializable()
class WalletTransactions {
  final List<Transaction> data;

  WalletTransactions(this.data);

  factory WalletTransactions.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionsFromJson(json);

  Map<String, dynamic> toJson() => _$WalletTransactionsToJson(this);
}
