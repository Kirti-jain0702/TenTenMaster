import 'package:delivoo/JsonFiles/Wallet/Transaction/transaction.dart';
import 'package:delivoo/JsonFiles/Wallet/get_wallet_balance.dart';
import 'package:equatable/equatable.dart';

abstract class WalletState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadingWalletState extends WalletState {}

class SuccessWalletState extends WalletState {
  final WalletBalance walletBalance;
  final List<Transaction> walletTransactions;

  SuccessWalletState(this.walletBalance, this.walletTransactions);

  @override
  List<Object> get props => [walletBalance, walletTransactions];
}

class WalletRechargeState extends WalletState {
  final bool paid;

  WalletRechargeState(this.paid);

  @override
  List<Object> get props => [paid];
}

class FailureWalletState extends WalletState {
  final String errorMessage;

  FailureWalletState([this.errorMessage]);

  @override
  List<Object> get props => [errorMessage];
}
