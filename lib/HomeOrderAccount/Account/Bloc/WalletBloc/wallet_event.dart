import 'package:delivoo/UtilityFunctions/card_picker.dart';
import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class FetchWalletEvent extends WalletEvent {}

class DepositWalletEvent extends WalletEvent {
  final String amount;
  final String paymentMethodSlug;
  final CardInfo cardInfo;

  DepositWalletEvent(this.amount, this.paymentMethodSlug, this.cardInfo);

  @override
  List<Object> get props => [amount, paymentMethodSlug, this.cardInfo];

  @override
  bool get stringify => true;
}
