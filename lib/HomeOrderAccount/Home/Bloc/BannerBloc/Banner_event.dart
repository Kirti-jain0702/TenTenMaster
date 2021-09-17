import 'package:equatable/equatable.dart';

abstract class BannerEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class FetchBannerEvent extends BannerEvent {}
