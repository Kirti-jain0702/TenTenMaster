import 'package:delivoo/JsonFiles/PaymentMethod/payment_method.dart';
import 'package:delivoo/Payment/PaymentBloc/payment_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class InitialPaymentState extends PaymentState {}

class LoadingPaymentState extends PaymentState {}

class ProcessingPaymentState extends PaymentState {}

class ProcessedPaymentState extends PaymentState {
  final PaymentStatus paymentStatus;
  ProcessedPaymentState(this.paymentStatus);
  @override
  List<Object> get props => [paymentStatus];
}

class LoadPaymentUrlState extends PaymentState {
  final String paymentLink, sUrl, fUrl;
  LoadPaymentUrlState(this.paymentLink, this.sUrl, this.fUrl);
  @override
  List<Object> get props => [paymentLink];
}

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
