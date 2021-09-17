import 'package:delivoo/JsonFiles/Order/Get/order_data.dart';
import 'package:equatable/equatable.dart';

abstract class OrdersEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

//List order events
class FetchOrdersEvent extends OrdersEvent {}

class PaginateOrdersEvent extends OrdersEvent {}

//Single order events
class FetchOrderUpdatesEvent extends OrdersEvent {}

class OrderUpdatedEvent extends OrdersEvent {
  final OrderData orderData;

  OrderUpdatedEvent(this.orderData);

  @override
  List<Object> get props => [orderData];
}
