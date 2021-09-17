import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class MobileState {
  final bool isNumberValid;
  final bool isSubmitting;
  final Success success;
  final bool isFailure;

  MobileState({
    @required this.isNumberValid,
    @required this.isSubmitting,
    @required this.success,
    @required this.isFailure,
  });

  factory MobileState.empty() {
    return MobileState(
      isNumberValid: true,
      isSubmitting: false,
      success: SuccessUninitialized(),
      isFailure: false,
    );
  }

  factory MobileState.invalidNumber() {
    return MobileState(
      isNumberValid: false,
      isSubmitting: false,
      success: SuccessUninitialized(),
      isFailure: false,
    );
  }

  factory MobileState.loading() {
    return MobileState(
      isNumberValid: true,
      isSubmitting: true,
      success: SuccessUninitialized(),
      isFailure: false,
    );
  }

  factory MobileState.successOf(
      {@required bool isRegistered, @required String normalizedPhoneNumber}) {
    return MobileState(
      isNumberValid: true,
      isSubmitting: false,
      success: SuccessInitialized(isRegistered, normalizedPhoneNumber),
      isFailure: false,
    );
  }

  factory MobileState.failure() {
    return MobileState(
      isNumberValid: true,
      isSubmitting: false,
      success: SuccessUninitialized(),
      isFailure: true,
    );
  }

  @override
  String toString() {
    return 'MobileState{isNumberValid: $isNumberValid, isSubmitting: $isSubmitting, success: $success, isFailure: $isFailure}';
  }
}

abstract class Success extends Equatable {
  @override
  List<Object> get props => [];
}

class SuccessUninitialized extends Success {}

class SuccessInitialized extends Success {
  final bool isRegistered;
  final String normalizedPhoneNumber;

  SuccessInitialized(this.isRegistered, this.normalizedPhoneNumber);

  @override
  List<Object> get props => [isRegistered, normalizedPhoneNumber];

  @override
  bool get stringify => true;
}
