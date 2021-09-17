import 'package:delivoo/JsonFiles/PaymentMethod/payment_method.dart';
import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadingPaymentState extends PaymentState {}

class SuccessPaymentState extends PaymentState {
  final List<PaymentMethod> listOfPaymentMethods;
  SuccessPaymentState(this.listOfPaymentMethods);

  @override
  List<Object> get props => [listOfPaymentMethods];
}

class FailurePaymentState extends PaymentState {
  final e;
  FailurePaymentState(this.e);

  @override
  List<Object> get props => [e];
}
