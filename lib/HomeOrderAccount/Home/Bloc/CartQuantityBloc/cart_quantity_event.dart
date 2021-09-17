import 'package:equatable/equatable.dart';

abstract class CartQuantityEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class UpdateCartQuantityEvent extends CartQuantityEvent {
  final int quantity;

  UpdateCartQuantityEvent(this.quantity);

  @override
  List<Object> get props => [quantity];
}

class GetCartQuantityEvent extends CartQuantityEvent {}
