import 'package:equatable/equatable.dart';

class CartQuantityState extends Equatable {
  final int quantity;

  CartQuantityState(this.quantity);
  @override
  List<Object> get props => [quantity];
}
