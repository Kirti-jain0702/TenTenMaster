import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:delivoo/AppConfig/app_config.dart';
import 'package:delivoo/HomeOrderAccount/ProductRepository/product_repository.dart';
import 'package:delivoo/JsonFiles/PaymentMethod/payment_method.dart';
import 'package:delivoo/JsonFiles/PaymentMethod/wallet_payment_response.dart';
import 'package:delivoo/Payment/PaymentBloc/payment_event.dart';
import 'package:delivoo/Payment/PaymentBloc/payment_state.dart';
import 'package:delivoo/Payment/process_payment_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentStatus {
  final bool isPaid;
  final String paidVia;
  PaymentStatus(this.isPaid, this.paidVia);
}

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  ProductRepository _repository = ProductRepository();
  String _sUrl, _fUrl, _currentPaymentMethod;

  PaymentBloc() : super(InitialPaymentState());

  @override
  Stream<PaymentState> mapEventToState(PaymentEvent event) async* {
    if (event is FetchPaymentEvent) {
      yield* _mapFetchPaymentToState(event.slugsToIgnore);
    } else if (event is FetchPrepaidPaymentEvent) {
      yield* _mapFetchPrepaidPaymentToState();
    } else if (event is InitPaymentProcessEvent) {
      yield* _mapInitPaymentProcessToState(event.paymentData);
    } else if (event is SetPaymentProcessedEvent) {
      yield* _mapSetPaymentProcessedToState(event.paid);
    }
  }

  Stream<PaymentState> _mapFetchPaymentToState(
      [List<String> slugsToIgnore]) async* {
    yield LoadingPaymentState();
    try {
      List<PaymentMethod> listPayment = await _repository.getPaymentMethod();
      listPayment.removeWhere((element) => (element.enabled == null ||
          element.enabled != 1 ||
          (slugsToIgnore != null && slugsToIgnore.contains(element.slug))));
      yield SuccessPaymentState(listPayment);
    } catch (e) {
      yield FailurePaymentState(e);
    }
  }

  Stream<PaymentState> _mapFetchPrepaidPaymentToState() async* {
    yield LoadingPaymentState();
    try {
      List<PaymentMethod> listPayment =
          await _repository.getPrepaidPaymentMethod();
      yield SuccessPaymentState(listPayment);
    } catch (e) {
      yield FailurePaymentState(e);
    }
  }

  Stream<PaymentState> _mapInitPaymentProcessToState(
      PaymentData paymentData) async* {
    yield ProcessingPaymentState();
    _currentPaymentMethod = (paymentData.payment?.paymentMethod?.slug ?? "");
    switch (_currentPaymentMethod) {
      case "cod":
        yield ProcessedPaymentState(PaymentStatus(true, _currentPaymentMethod));
        break;
      case "wallet":
        try {
          WalletPaymentResponse walletPaymentResponse =
              await _repository.payThroughWallet(paymentData.payment?.id ?? -1);
          yield ProcessedPaymentState(PaymentStatus(
              walletPaymentResponse.success, _currentPaymentMethod));
        } catch (e) {
          print("processPayment wallet $e");
          yield ProcessedPaymentState(
              PaymentStatus(false, _currentPaymentMethod));
        }
        break;
      case "stripe":
        try {
          WalletPaymentResponse walletPaymentResponse =
              await _repository.payThroughStripe(
                  paymentData.payment?.id ?? -1, paymentData.stripeTokenId);
          yield ProcessedPaymentState(PaymentStatus(
              walletPaymentResponse.success, _currentPaymentMethod));
        } catch (e) {
          print("processPayment stripe $e");
          yield ProcessedPaymentState(
              PaymentStatus(false, _currentPaymentMethod));
        }
        break;
      case "payu":
        try {
          String key =
              paymentData.payment.paymentMethod.getMetaKey("public_key");
          String salt =
              paymentData.payment.paymentMethod.getMetaKey("private_key");
          if (key != null && salt != null) {
            String name = paymentData.payuMeta.name;
            String mobile = paymentData.payuMeta.mobile;
            String email = paymentData.payuMeta.email;
            String bookingId = paymentData.payuMeta.bookingId;
            String productinfo = paymentData.payuMeta.productinfo;
            String amt = "${paymentData.payment.amount}";
            //  String amt = "1.00";
            String checksum = key +
                "|" +
                bookingId +
                "|" +
                amt +
                "|" +
                productinfo +
                "|" +
                name +
                "|" +
                email +
                '|||||||||||' +
                salt;
            var bytes = utf8.encode(checksum);
            Digest sha512Result = sha512.convert(bytes);
            String encrypttext = sha512Result.toString();
            String furl =
                "${AppConfig.baseUrl}api/payment/payu/${paymentData.payment.id}?result=failed";
            String surl =
                "${AppConfig.baseUrl}api/payment/payu/${paymentData.payment.id}?result=success";


            String url =
                "${AppConfig.baseUrl}assets/vendor/payment/payumoney/payuBiz.html?amt=$amt&name=$name&mobileNo=$mobile&email=$email&bookingId=$bookingId&productinfo=$productinfo&hash=$encrypttext&salt=$salt&key=$key&furl=$furl&surl=$surl";

            print("gotUrlHere> $url");
            _sUrl = surl;
            _fUrl = furl;
            yield LoadPaymentUrlState(url, surl, furl);
          } else {
            print("processPayment payu top");

            yield ProcessedPaymentState(
                PaymentStatus(false, _currentPaymentMethod));
          }
        } catch (e) {
          print("processPayment payu $e");
          yield ProcessedPaymentState(
              PaymentStatus(false, _currentPaymentMethod));
        }
        break;
      case "paystack":
        String url =
            "${AppConfig.baseUrl}api/payment/paystack/${paymentData.payment.id}";
        _sUrl =
            "${AppConfig.baseUrl}api/payment/paystack/callback/${paymentData.payment.id}?result=success";
        _fUrl =
            "${AppConfig.baseUrl}api/payment/paystack/callback/${paymentData.payment.id}?result=error";
        yield LoadPaymentUrlState(url, _sUrl, _fUrl);
        break;
      default:
        print("processPayment unknown payment method");
        yield ProcessedPaymentState(
            PaymentStatus(false, _currentPaymentMethod));
        break;
    }
  }

  Stream<PaymentState> _mapSetPaymentProcessedToState(bool paid) async* {
    yield ProcessingPaymentState();
    if (!paid && _currentPaymentMethod != null && _fUrl != null) {
      if (_currentPaymentMethod == "payu")
        await _repository.postUrl(_fUrl);
      else if (_currentPaymentMethod == "paystack")
        await _repository.getUrl(_fUrl);
    }
    yield ProcessedPaymentState(PaymentStatus(paid, _currentPaymentMethod));
  }
}
