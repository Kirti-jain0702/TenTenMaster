import 'package:json_annotation/json_annotation.dart';

part 'get_wallet_balance.g.dart';

@JsonSerializable()
class WalletBalance {
  final double balance;

  WalletBalance(this.balance);

  factory WalletBalance.fromJson(Map<String, dynamic> json) =>
      _$WalletBalanceFromJson(json);

  Map<String, dynamic> toJson() => _$WalletBalanceToJson(this);
}
