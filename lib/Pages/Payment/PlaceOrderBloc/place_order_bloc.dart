import 'package:delivoo/HomeOrderAccount/ProductRepository/product_repository.dart';
import 'package:delivoo/JsonFiles/Order/Get/order_data.dart';
import 'package:delivoo/JsonFiles/Order/Post/create_order.dart';
import 'package:delivoo/JsonFiles/PaymentMethod/wallet_payment_response.dart';
import 'package:delivoo/JsonFiles/Wallet/get_wallet_balance.dart';
import 'package:delivoo/Pages/Payment/PlaceOrderBloc/place_order_event.dart';
import 'package:delivoo/Pages/Payment/PlaceOrderBloc/place_order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
            placeOrderEvent.paymentMethod.getMetaStripe();
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
          yield FailurePlaceOrderState("card_verification_fail");
        }
      } catch (e) {
        print("StripePaymentError: $e");
        yield FailurePlaceOrderState("card_verification_fail");
      }
    } else {
      yield* _placeOrder(placeOrderEvent.createOrder);
    }
  }

  Stream<PlaceOrderState> _placeOrder(CreateOrder createOrder) async* {
    yield LoadingPlaceOrderState();
    try {
      OrderData orderData = await _productRepository.postOrder(createOrder);
      var prefs = await SharedPreferences.getInstance();
      prefs.remove("cart_products");
      if (orderData.payment.paymentMethod.slug == "cod") {
        yield SuccessPlaceOrderState(true);
      } else if (orderData.payment.paymentMethod.slug == "wallet") {
        yield* _initPaymentWallet(orderData.payment.id);
      } else if (orderData.payment.paymentMethod.slug == "stripe" &&
          _stripeTokenId != null) {
        yield* _initPaymentStripe(orderData.payment.id);
      } else {
        yield FailurePlaceOrderState("something_went_wrong");
      }
    } catch (e) {
      yield FailurePlaceOrderState("something_went_wrong");
    }
  }

  Stream<PlaceOrderState> _initPaymentWallet(int paymentId) async* {
    yield LoadingPaymentOrderState();
    try {
      WalletPaymentResponse walletPaymentResponse =
          await _productRepository.payThroughWallet(paymentId);
      yield SuccessPlaceOrderState(walletPaymentResponse.success);
    } catch (e) {
      print(e);
      yield SuccessPlaceOrderState(false);
    }
  }

  Stream<PlaceOrderState> _initPaymentStripe(int paymentId) async* {
    yield LoadingPaymentOrderState();
    try {
      WalletPaymentResponse walletPaymentResponse =
          await _productRepository.payThroughStripe(paymentId, _stripeTokenId);
      yield SuccessPlaceOrderState(walletPaymentResponse.success);
    } catch (e) {
      print(e);
      yield SuccessPlaceOrderState(false);
    }
  }
}
