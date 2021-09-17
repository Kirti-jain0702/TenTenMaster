import 'package:delivoo/Cart/coupon.dart';
import 'package:delivoo/HomeOrderAccount/HomeRepository/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'offer_event.dart';
import 'offer_state.dart';

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  HomeRepository _homeRepository = HomeRepository();

  OfferBloc() : super(OfferInitialState());

  @override
  Stream<OfferState> mapEventToState(OfferEvent event) async* {
    switch (event.runtimeType) {
      case OffersFetchEvent:
        yield* _mapOffersFetchState();
        break;
      case OfferVerifyEvent:
        yield* _mapOfferVerifyState((event as OfferVerifyEvent).cCode);
        break;
    }
  }

  Stream<OfferState> _mapOfferVerifyState(String couponCode) async* {
    yield OfferLoadingState();
    try {
      Coupon coupon = await _homeRepository.verifyCoupon(couponCode);
      if (coupon.isValid())
        yield OfferValidState(coupon);
      else
        yield OfferInValidState();
    } catch (e) {
      print(e);
      yield OfferInValidState();
    }
  }

  Stream<OfferState> _mapOffersFetchState() async* {
    yield OfferLoadingState();
    try {
      List<Coupon> coupons = await _homeRepository.getCoupons();
      for (Coupon coupon in coupons) coupon.setup();
      yield OfferLoadedState(coupons);
    } catch (e) {
      print(e);
      yield OfferErrorState();
    }
  }
}
