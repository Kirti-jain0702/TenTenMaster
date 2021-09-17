import 'package:equatable/equatable.dart';

abstract class SocialLoginEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoginWithFacebookPressed extends SocialLoginEvent {}

class LoginWithGooglePressed extends SocialLoginEvent {}
