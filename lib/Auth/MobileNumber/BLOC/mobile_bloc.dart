import 'package:bloc/bloc.dart';
import 'package:delivoo/Auth/AuthRepo/auth_repository.dart';
import 'package:libphonenumber/libphonenumber.dart';

import 'mobile_event.dart';
import 'mobile_state.dart';

class MobileBloc extends Bloc<MobileEvent, MobileState> {
  AuthRepo _userRepository = AuthRepo();

  MobileBloc() : super(MobileState.empty());

  @override
  Stream<MobileState> mapEventToState(MobileEvent event) async* {
    if (event is SubmittedEvent) {
      yield* _mapSubmitToState(event.isoCode, event.mobileNumber);
    }
  }

  Stream<MobileState> _mapSubmitToState(
      String isoCode, String mobileNumber) async* {
    bool isValid = await PhoneNumberUtil.isValidPhoneNumber(
        phoneNumber: mobileNumber, isoCode: isoCode);
    if (isValid) {
      yield MobileState.loading();
      try {
        String normalizedNumber = await PhoneNumberUtil.normalizePhoneNumber(
            phoneNumber: mobileNumber, isoCode: isoCode);
        bool isRegistered =
            await _userRepository.isRegistered(normalizedNumber);
        yield MobileState.successOf(
            isRegistered: isRegistered,
            normalizedPhoneNumber: normalizedNumber);
      } catch (e) {
        yield MobileState.failure();
      }
    } else {
      yield MobileState.invalidNumber();
    }
  }

//  bool isNumberValid(String number) {
//    RegExp phonePattern = RegExp('^\\d{10}\$');
//    return phonePattern.hasMatch(number);
//  }
}
