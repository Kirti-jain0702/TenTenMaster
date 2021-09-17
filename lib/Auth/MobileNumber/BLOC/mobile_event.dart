import 'package:equatable/equatable.dart';

abstract class MobileEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class SubmittedEvent extends MobileEvent {
  final String isoCode;
  final String mobileNumber;

  SubmittedEvent(this.isoCode, this.mobileNumber);

  @override
  List<Object> get props => [isoCode, mobileNumber];
}
