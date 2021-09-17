import 'package:delivoo/Items/items_tab.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_quantity_event.dart';
import 'cart_quantity_state.dart';

class CartQuantityBloc extends Bloc<CartQuantityEvent, CartQuantityState> {
  CartQuantityBloc() : super(CartQuantityState(cartProducts.length));

  @override
  Stream<CartQuantityState> mapEventToState(CartQuantityEvent event) async* {
    if (event is UpdateCartQuantityEvent && event.quantity == 0)
      cartProducts.clear();
    yield CartQuantityState(event is UpdateCartQuantityEvent
        ? event.quantity
        : cartProducts.length);
  }
}
