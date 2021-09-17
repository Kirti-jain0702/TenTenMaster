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
  final bool paid;

  SuccessPlaceOrderState(this.paid);

  @override
  List<Object> get props => [paid];
}

class FailurePlaceOrderState extends PlaceOrderState {
  final String errorMessage;

  FailurePlaceOrderState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
