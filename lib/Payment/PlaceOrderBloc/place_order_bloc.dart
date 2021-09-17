import 'dart:math';

import 'package:delivoo/HomeOrderAccount/ProductRepository/product_repository.dart';
import 'package:delivoo/JsonFiles/Order/Get/order_data.dart';
import 'package:delivoo/JsonFiles/Order/Post/create_order.dart';
import 'package:delivoo/JsonFiles/Wallet/get_wallet_balance.dart';
import 'package:delivoo/Payment/PlaceOrderBloc/place_order_event.dart';
import 'package:delivoo/Payment/PlaceOrderBloc/place_order_state.dart';
import 'package:delivoo/Payment/process_payment_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PlaceOrderBloc extends Bloc<PlaceOrderEvent, PlaceOrderState> {
  ProductRepository _productRepository = ProductRepository();
  String _stripeTokenId;

  PlaceOrderBloc() : super(LoadingPlaceOrderState());

  @override
  Stream<PlaceOrderState> mapEventToState(PlaceOrderEvent event) async* {
    if (event is PlaceOrderEvent) {
      yield* _mapPostPlaceOrderToState(event);
    }
  }

  Stream<PlaceOrderState> _mapPostPlaceOrderToState(
      PlaceOrderEvent placeOrderEvent) async* {
    yield LoadingPlaceOrderState();
    if (placeOrderEvent.paymentMethod.slug == "wallet") {
      try {
        WalletBalance walletBalance = await _productRepository.getBalance();
        if (placeOrderEvent.totalPrice > walletBalance.balance) {
          yield FailurePlaceOrderState("insufficient_wallet");
        } else {
          yield* _placeOrder(placeOrderEvent.createOrder);
        }
      } catch (e) {
        yield FailurePlaceOrderState("insufficient_wallet_verification");
      }
    } else if (placeOrderEvent.paymentMethod.slug == "stripe") {
      try {
        String stripePublishableKey =
            placeOrderEvent.paymentMethod.getMetaKey("public_key");
        if (stripePublishableKey != null) {
          StripePayment.setOptions(
              StripeOptions(publishableKey: stripePublishableKey));
          Token token = await StripePayment.createTokenWithCard(CreditCard(
              number: placeOrderEvent.cardInfo.cardNumber,
              expMonth: placeOrderEvent.cardInfo.cardMonth,
              expYear: placeOrderEvent.cardInfo.cardYear,
              cvc: placeOrderEvent.cardInfo.cardCvv));
          if (token != null && token.tokenId != null) {
            _stripeTokenId = token.tokenId;
          } else {
            yield FailurePlaceOrderState("card_verification_fail");
          }
          yield* _placeOrder(placeOrderEvent.createOrder);
        } else {
          yield FailurePlaceOrderState("payment_setup_fail");
        }
      } catch (e) {
        print("StripePaymentError: $e");
        yield FailurePlaceOrderState("card_verification_fail");
      }
    } else if (placeOrderEvent.paymentMethod.slug == "payu") {
      try {
        //String key = "gtKFFx";
        //String salt = "eCwWELxi";
        String key = placeOrderEvent.paymentMethod.getMetaKey("public_key");
        String salt = placeOrderEvent.paymentMethod.getMetaKey("private_key");
        if (key != null && salt != null) {

          print("gotCahWar >> ${placeOrderEvent.createOrder.toJson()}");
          yield* _placeOrder(placeOrderEvent.createOrder,price: placeOrderEvent.totalPrice);

        } else {
          print("PayuPaymentErrorTOP: ${e}");
          yield FailurePlaceOrderState("payment_setup_fail");
        }
      } catch (e) {
        print("PayuPaymentError: $e");
        yield FailurePlaceOrderState("payment_setup_fail");
      }
    } else {
      print("gotCahWar >> ${placeOrderEvent.createOrder.toJson()}");
      yield* _placeOrder(placeOrderEvent.createOrder);
    }
  }

  Stream<PlaceOrderState> _placeOrder(CreateOrder createOrder,{double price}) async* {
    print("insideGOTT > ");
    yield LoadingPlaceOrderState();
    try {
      OrderData orderData = await _productRepository.postOrder(createOrder,price:price);
      yield SuccessPlaceOrderState(
        PaymentData(
          payment: orderData.payment,
          payuMeta: PayUMeta(
            name: orderData.user.name.replaceAll(' ', ''),
            mobile: orderData.user.mobileNumber.replaceAll(' ', ''),
            email: orderData.user.email.replaceAll(' ', ''),
            bookingId: "${Random().nextInt(999) + 10}${orderData.id}",
            productinfo: orderData.vendor.name.replaceAll(' ', ''),
          ),
          stripeTokenId: _stripeTokenId,
        ),
      );
    } catch (e) {
      print("errorsGoes >> $e");
      yield FailurePlaceOrderState("something_went_wrong");
    }
  }
}
