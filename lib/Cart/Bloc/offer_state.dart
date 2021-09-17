import 'package:delivoo/Cart/coupon.dart';
import 'package:equatable/equatable.dart';

class OfferInitialState extends OfferState {}

class OfferLoadingState extends OfferState {}

class OfferLoadedState extends OfferState {
  final List<Coupon> coupons;

  OfferLoadedState(this.coupons);

  @override
  List<Object> get props => [coupons];
}

class OfferValidState extends OfferState {
  final Coupon coupon;

  OfferValidState(this.coupon);

  @override
  List<Object> get props => [coupon];
}

class OfferInValidState extends OfferState {}

class OfferErrorState extends OfferState {}

class OfferState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}
