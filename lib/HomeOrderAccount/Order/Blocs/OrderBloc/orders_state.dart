import 'package:delivoo/JsonFiles/Order/Get/order_data.dart';
import 'package:equatable/equatable.dart';

abstract class OrdersState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

//States for list of orders.
class LoadingOrdersState extends OrdersState {}

class SuccessOrdersState extends OrdersState {
  final List<OrderData> orders;

  SuccessOrdersState(this.orders);

  @override
  List<Object> get props => [orders];
}

class FailureOrdersState extends OrdersState {
  final e;

  FailureOrdersState(this.e);

  @override
  List<Object> get props => [e];
}

//States for single order.
class OrderSuccess extends OrdersState {
  final OrderData order;

  OrderSuccess(this.order);

  @override
  List<Object> get props => [order];
}
