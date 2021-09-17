import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SocialLoginState {
  final bool isSubmitting;
  final Success success;
  final bool isFailure;

  SocialLoginState({
    @required this.isSubmitting,
    @required this.success,
    @required this.isFailure,
  });

  factory SocialLoginState.initial() {
    return SocialLoginState(
      isSubmitting: false,
      success: SuccessUninitialized(),
      isFailure: false,
    );
  }
  factory SocialLoginState.loading() {
    return SocialLoginState(
      isSubmitting: true,
      success: SuccessUninitialized(),
      isFailure: false,
    );
  }

  factory SocialLoginState.success() {
    return SocialLoginState(
      isSubmitting: false,
      success: SuccessUninitialized(),
      isFailure: false,
    );
  }

  factory SocialLoginState.successOf({@required bool isRegistered}) {
    return SocialLoginState(
      isSubmitting: false,
      success: SuccessInitialized(isRegistered),
      isFailure: false,
    );
  }

  factory SocialLoginState.failure() {
    return SocialLoginState(
      isSubmitting: false,
      success: SuccessUninitialized(),
      isFailure: true,
    );
  }
}

abstract class Success extends Equatable {
  @override
  List<Object> get props => [];
}

class SuccessUninitialized extends Success {}

class SuccessInitialized extends Success {
  final bool isRegistered;

  SuccessInitialized(this.isRegistered);

  @override
  List<Object> get props => [isRegistered];

  @override
  bool get stringify => true;
}
