import 'package:delivoo/HomeOrderAccount/Account/Bloc/WalletBloc/wallet_event.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/WalletBloc/wallet_state.dart';
import 'package:delivoo/HomeOrderAccount/ProductRepository/product_repository.dart';
import 'package:delivoo/JsonFiles/Order/Get/payment.dart';
import 'package:delivoo/JsonFiles/PaymentMethod/payment_method.dart'
    as MyPaymentMethod;
import 'package:delivoo/JsonFiles/PaymentMethod/wallet_payment_response.dart';
import 'package:delivoo/JsonFiles/Wallet/Transaction/get_wallet_transactions.dart';
import 'package:delivoo/JsonFiles/Wallet/Transaction/transaction.dart';
import 'package:delivoo/JsonFiles/Wallet/get_wallet_balance.dart';
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
      if (depositWalletEvent.paymentMethodSlug == "stripe") {
        MyPaymentMethod.PaymentMethod stripePaymentMethod;
        try {
          List<MyPaymentMethod.PaymentMethod> list =
              await _repository.getPaymentMethod();
          stripePaymentMethod =
              list.firstWhere((element) => element.slug == "stripe");
        } catch (e) {
          print(e);
          yield FailureWalletState();
        }
        if (stripePaymentMethod != null) {
          try {
            String stripePublishableKey = stripePaymentMethod.getMetaStripe();
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
              yield* _depositWallet(depositWalletEvent.amount,
                  depositWalletEvent.paymentMethodSlug);
            } else {
              yield FailureWalletState("card_verification_fail");
            }
          } catch (e) {
            print("StripePaymentError: $e");
            yield FailureWalletState();
          }
        } else {
          yield FailureWalletState();
        }
      } else {
        yield FailureWalletState();
      }
    } catch (e) {
      yield FailureWalletState();
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
      yield FailureWalletState();
    }
  }

  Stream<WalletState> _depositWallet(
      String amount, String paymentMethodSlug) async* {
    yield LoadingWalletState();
    try {
      Payment payment =
          await _repository.depositWallet(amount, paymentMethodSlug);
      if (payment.paymentMethod.slug == "stripe" && _stripeTokenId != null) {
        yield* _initPaymentStripe(payment.id);
      }
    } catch (e) {
      yield FailureWalletState();
    }
  }

  Stream<WalletState> _initPaymentStripe(int paymentId) async* {
    yield LoadingWalletState();
    try {
      WalletPaymentResponse walletPaymentResponse =
          await _repository.payThroughStripe(paymentId, _stripeTokenId);
      yield WalletRechargeState(walletPaymentResponse.success);
    } catch (e) {
      print(e);
      yield WalletRechargeState(false);
    }
  }
}
