import 'package:equatable/equatable.dart';

class OfferVerifyEvent extends OfferEvent {
  final String cCode;

  OfferVerifyEvent(this.cCode);

  @override
  List<Object> get props => [cCode];
}

class OffersFetchEvent extends OfferEvent {}

class OfferEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}
