part of 'verification_cubit.dart';

abstract class VerificationState {
  const VerificationState();
//CREATE STATES FOR sending code, code sent, verifying otp, otp verified.
}

class VerificationLoading extends VerificationState {
  const VerificationLoading();
}

class VerificationLoaded extends VerificationState {
  const VerificationLoaded();
}

class VerificationSendingLoading extends VerificationLoading {
  const VerificationSendingLoading();
}

class VerificationVerifyingLoading extends VerificationLoading {
  const VerificationVerifyingLoading();
}

class VerificationSentLoaded extends VerificationLoaded {
  VerificationSentLoaded();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerificationSentLoaded && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class VerificationVerifyingLoaded extends VerificationLoaded {
  final LoginResponse authResponse;

  VerificationVerifyingLoaded(this.authResponse);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerificationVerifyingLoaded &&
          runtimeType == other.runtimeType &&
          authResponse == other.authResponse;

  @override
  int get hashCode => authResponse.hashCode;
}

class VerificationError extends VerificationState {
  final String message, messageKey;

  const VerificationError(this.message, this.messageKey);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerificationError &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          messageKey == other.messageKey;

  @override
  int get hashCode => message.hashCode ^ messageKey.hashCode;
}
