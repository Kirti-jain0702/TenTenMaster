import 'package:delivoo/JsonFiles/Wallet/Transaction/transaction.dart';
import 'package:delivoo/JsonFiles/Wallet/get_wallet_balance.dart';
import 'package:delivoo/Payment/process_payment_page.dart';
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

class WalletDepositState extends WalletState {
  final PaymentData paymentData;

  WalletDepositState(this.paymentData);

  @override
  List<Object> get props => [paymentData];
}

class FailureWalletState extends WalletState {
  final String errorMessage;

  FailureWalletState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
