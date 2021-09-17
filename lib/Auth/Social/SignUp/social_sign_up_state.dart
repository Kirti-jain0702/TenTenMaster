import 'package:meta/meta.dart';

@immutable
class SocialSignUpState {
  final bool isNumberValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String number;

  SocialSignUpState({
    @required this.isNumberValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    this.number,
  });

  factory SocialSignUpState.empty() {
    return SocialSignUpState(
      isNumberValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      number: '',
    );
  }

  factory SocialSignUpState.invalidNumber(
      {@required String normalizedPhoneNumber}) {
    return SocialSignUpState(
      isNumberValid: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      number: normalizedPhoneNumber,
    );
  }

  factory SocialSignUpState.loading() {
    return SocialSignUpState(
      isNumberValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      number: '',
    );
  }

  factory SocialSignUpState.success({@required String normalizedPhoneNumber}) {
    return SocialSignUpState(
        isNumberValid: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false,
        number: normalizedPhoneNumber);
  }

  factory SocialSignUpState.failure() {
    return SocialSignUpState(
      isNumberValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  @override
  String toString() {
    return 'LinkMobileState{isNumberValid: $isNumberValid, isSubmitting: $isSubmitting, isSuccess: $isSuccess, isFailure: $isFailure, number: $number}';
  }
}
