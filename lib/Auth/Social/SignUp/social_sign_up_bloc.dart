import 'package:delivoo/Auth/AuthRepo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libphonenumber/libphonenumber.dart';

import 'social_sign_up_event.dart';
import 'social_sign_up_state.dart';

class SocialSignUpBloc extends Bloc<SocialSignUpEvent, SocialSignUpState> {
  AuthRepo _userRepository = AuthRepo();

  SocialSignUpBloc() : super(SocialSignUpState.empty());

  @override
  Stream<SocialSignUpState> mapEventToState(SocialSignUpEvent event) async* {
    if (event is SocialSignUpSubmittedEvent) {
      yield* _mapSubmittedEventToState(
          event.isoCode, event.mobileNumber, event.name, event.email);
    }
  }

  Stream<SocialSignUpState> _mapSubmittedEventToState(
      String isoCode, String mobileNumber, String name, String email) async* {
    bool isValid = await PhoneNumberUtil.isValidPhoneNumber(
        phoneNumber: mobileNumber, isoCode: isoCode);
    if (isValid) {
      yield SocialSignUpState.loading();
      try {
        String normalizedNumber = await PhoneNumberUtil.normalizePhoneNumber(
            phoneNumber: mobileNumber, isoCode: isoCode);
        await _userRepository.registerUser(normalizedNumber, name, email);
        yield SocialSignUpState.success(
            normalizedPhoneNumber: normalizedNumber);
      } catch (e) {
        print('social error: ' + e.toString());
        yield SocialSignUpState.failure();
      }
    } else {
      yield SocialSignUpState.invalidNumber(
          normalizedPhoneNumber: 'Invalid Number');
    }
  }
}
