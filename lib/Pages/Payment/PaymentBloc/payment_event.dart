import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class FetchPaymentEvent extends PaymentEvent {}

class FetchPrepaidPaymentEvent extends PaymentEvent {}
