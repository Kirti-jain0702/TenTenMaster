import 'package:delivoo/JsonFiles/Order/Post/create_order.dart';
import 'package:delivoo/JsonFiles/PaymentMethod/payment_method.dart';
import 'package:delivoo/UtilityFunctions/card_picker.dart';
import 'package:equatable/equatable.dart';

class PlaceOrderEvent extends Equatable {
  final CreateOrder createOrder;
  final PaymentMethod paymentMethod;
  final double totalPrice;
  final CardInfo cardInfo;

  PlaceOrderEvent(
      this.totalPrice, this.paymentMethod, this.cardInfo, this.createOrder);

  @override
  List<Object> get props => [createOrder, paymentMethod, createOrder, cardInfo];

  @override
  bool get stringify => true;
}
