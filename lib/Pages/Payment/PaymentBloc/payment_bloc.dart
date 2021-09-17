import 'package:delivoo/HomeOrderAccount/ProductRepository/product_repository.dart';
import 'package:delivoo/JsonFiles/PaymentMethod/payment_method.dart';
import 'package:delivoo/Pages/Payment/PaymentBloc/payment_event.dart';
import 'package:delivoo/Pages/Payment/PaymentBloc/payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  ProductRepository _repository = ProductRepository();

  PaymentBloc() : super(LoadingPaymentState());

  @override
  Stream<PaymentState> mapEventToState(PaymentEvent event) async* {
    if (event is FetchPaymentEvent) {
      yield* _mapFetchPaymentToState();
    } else if (event is FetchPrepaidPaymentEvent) {
      yield* _mapFetchPrepaidPaymentToState();
    }
  }

  Stream<PaymentState> _mapFetchPaymentToState() async* {
    yield LoadingPaymentState();
    try {
      List<PaymentMethod> listPayment = await _repository.getPaymentMethod();
      listPayment.removeWhere(
          (element) => (element.enabled == null || element.enabled != 1));
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
}
