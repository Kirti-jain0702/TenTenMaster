import 'package:delivoo/Payment/process_payment_page.dart';
import 'package:equatable/equatable.dart';

class PlaceOrderState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadingPlaceOrderState extends PlaceOrderState {}

class LoadingPaymentOrderState extends LoadingPlaceOrderState {}

class SuccessPlaceOrderState extends PlaceOrderState {
  final PaymentData paymentData;

  SuccessPlaceOrderState(this.paymentData);

  @override
  List<Object> get props => [paymentData];
}

class FailurePlaceOrderState extends PlaceOrderState {
  final String errorMessage;

  FailurePlaceOrderState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
