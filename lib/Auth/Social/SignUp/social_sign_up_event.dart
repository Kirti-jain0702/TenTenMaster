import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SocialSignUpEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class SocialSignUpSubmittedEvent extends SocialSignUpEvent {
  final String isoCode;
  final String mobileNumber;
  final String name;
  final String email;

  SocialSignUpSubmittedEvent(
      {@required this.isoCode,
      @required this.mobileNumber,
      @required this.name,
      @required this.email});

  @override
  List<Object> get props => [isoCode, mobileNumber, name, email];
}
