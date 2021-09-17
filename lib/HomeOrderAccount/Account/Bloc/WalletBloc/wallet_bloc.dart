import 'dart:math';

import 'package:delivoo/Auth/AuthRepo/auth_repository.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/WalletBloc/wallet_event.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/WalletBloc/wallet_state.dart';
import 'package:delivoo/HomeOrderAccount/ProductRepository/product_repository.dart';
import 'package:delivoo/JsonFiles/Auth/Responses/user_info.dart';
import 'package:delivoo/JsonFiles/Order/Get/payment.dart';
import 'package:delivoo/JsonFiles/Wallet/Transaction/get_wallet_transactions.dart';
import 'package:delivoo/JsonFiles/Wallet/Transaction/transaction.dart';
import 'package:delivoo/JsonFiles/Wallet/get_wallet_balance.dart';
import 'package:delivoo/Payment/process_payment_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_payment/stripe_payment.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(LoadingWalletState());

  ProductRepository _repository = ProductRepository();
  String _stripeTokenId;

  @override
  Stream<WalletState> mapEventToState(WalletEvent event) async* {
    if (event is FetchWalletEvent) {
      yield* _mapFetchWalletToState();
    } else if (event is DepositWalletEvent) {
      yield* _mapDepositWalletToState(event);
    }
  }

  Stream<WalletState> _mapDepositWalletToState(
      DepositWalletEvent depositWalletEvent) async* {
    yield LoadingWalletState();
    try {
      if (depositWalletEvent.paymentMethod.slug == "stripe") {
        try {
          String stripePublishableKey =
              depositWalletEvent.paymentMethod.getMetaKey("public_key");
          if (stripePublishableKey != null) {
            StripePayment.setOptions(
                StripeOptions(publishableKey: stripePublishableKey));
            Token token = await StripePayment.createTokenWithCard(CreditCard(
                number: depositWalletEvent.cardInfo.cardNumber,
                expMonth: depositWalletEvent.cardInfo.cardMonth,
                expYear: depositWalletEvent.cardInfo.cardYear,
                cvc: depositWalletEvent.cardInfo.cardCvv));
            if (token != null && token.tokenId != null) {
              _stripeTokenId = token.tokenId;
            } else {
              yield FailureWalletState("card_verification_fail");
            }
            yield* _depositWallet(
              depositWalletEvent.amount,
              depositWalletEvent.paymentMethod.slug,
            );
          } else {
            yield FailureWalletState("payment_setup_fail");
          }
        } catch (e) {
          print("StripePaymentError: $e");
          yield FailureWalletState("card_verification_fail");
        }
      } else if (depositWalletEvent.paymentMethod.slug == "payu") {
        try {
          String key =
              depositWalletEvent.paymentMethod.getMetaKey("public_key");
          String salt =
              depositWalletEvent.paymentMethod.getMetaKey("private_key");
          if (key != null && salt != null) {
            yield* _depositWallet(
              depositWalletEvent.amount,
              depositWalletEvent.paymentMethod.slug,
            );
          } else {
            yield FailureWalletState("payment_setup_fail");
          }
        } catch (e) {
          print("PayuPaymentError: $e");
          yield FailureWalletState("payment_setup_fail");
        }
      } else {
        yield* _depositWallet(
          depositWalletEvent.amount,
          depositWalletEvent.paymentMethod.slug,
        );
      }
    } catch (e) {
      print("_mapDepositWalletToState: $e");
      yield FailureWalletState("something_went_wrong");
    }
  }

  Stream<WalletState> _mapFetchWalletToState() async* {
    try {
      WalletBalance walletBalance = await _repository.getBalance();
      WalletTransactions walletTransactions =
          await _repository.getTransactions();
      for (Transaction transaction in walletTransactions.data)
        transaction.setup();
      yield SuccessWalletState(walletBalance, walletTransactions.data);
    } catch (e) {
      print("getTransactions: $e");
      yield FailureWalletState("something_went_wrong");
    }
  }

  Stream<WalletState> _depositWallet(
      String amount, String paymentMethodSlug) async* {
    yield LoadingWalletState();
    try {
      Payment payment =
          await _repository.depositWallet(amount, paymentMethodSlug);
      UserInformation userInfo = await AuthRepo().getUserInfo();
      yield WalletDepositState(
        PaymentData(
          payment: payment,
          payuMeta: PayUMeta(
            name: userInfo.name.replaceAll(' ', ''),
            mobile: userInfo.mobileNumber.replaceAll(' ', ''),
            email: userInfo.email.replaceAll(' ', ''),
            bookingId: "${Random().nextInt(999) + 10}${payment.id}",
            productinfo: "Wallet Recharge",
          ),
          stripeTokenId: _stripeTokenId,
        ),
      );
    } catch (e) {
      print("depositWallet: $e");
      yield FailureWalletState("something_went_wrong");
    }
  }
}
