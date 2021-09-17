import 'package:delivoo/JsonFiles/Banner/Banner.dart';
import 'package:equatable/equatable.dart';

abstract class BannerState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadingBannerState extends BannerState {}

class SuccessBannerState extends BannerState {
  final BannerData listOfBannerData;

  SuccessBannerState(this.listOfBannerData);
  @override
  List<Object> get props => [listOfBannerData];
}

class FailureBannerState extends BannerState {
  final Exception e;
  FailureBannerState(this.e);

  @override
  List<Object> get props => [e];
}
