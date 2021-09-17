import 'package:delivoo/Payment/process_payment_page.dart';
import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class FetchPaymentEvent extends PaymentEvent {
  final List<String> slugsToIgnore;
  FetchPaymentEvent([this.slugsToIgnore]);
  @override
  List<Object> get props => [slugsToIgnore];
}

class FetchPrepaidPaymentEvent extends PaymentEvent {}

class InitPaymentProcessEvent extends PaymentEvent {
  final PaymentData paymentData;
  InitPaymentProcessEvent(this.paymentData);
  @override
  List<Object> get props => [paymentData];
}

class SetPaymentProcessedEvent extends PaymentEvent {
  final bool paid;
  SetPaymentProcessedEvent(this.paid);
  @override
  List<Object> get props => [paid];
}
