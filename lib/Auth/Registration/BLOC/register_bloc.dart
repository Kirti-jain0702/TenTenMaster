import 'package:bloc/bloc.dart';
import 'package:delivoo/Auth/AuthRepo/auth_repository.dart';

import 'register_event.dart';
import 'register_state.dart';
import 'validators.dart';

class SignUpBloc extends Bloc<RegisterEvent, RegisterState> {
  AuthRepo _userRepository = AuthRepo();

  SignUpBloc() : super(RegisterState.empty());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is NameChangedEvent) {
      yield _mapNameChangedToState(event.name);
    } else if (event is EmailChangedEvent) {
      yield _mapEmailChangedToState(event.email);
    } else if (event is SubmittedEvent) {
      yield* _mapFormSubmittedToState(
          event.name, event.email, event.phoneNumber);
    }
  }

  RegisterState _mapNameChangedToState(String name) {
    return state.update(isNameValid: Validators.isNameValid(name));
  }

  RegisterState _mapEmailChangedToState(String email) {
    return state.update(isNameValid: Validators.isEmailValid(email));
  }

  Stream<RegisterState> _mapFormSubmittedToState(
      String name, String email, String phoneNumber) async* {
    yield RegisterState.loading();

    var nameValid = Validators.isNameValid(name);
    var emailValid = Validators.isEmailValid(email);

    bool isValid = nameValid && emailValid;

    if (isValid) {
      try {
        await _userRepository.registerUser(phoneNumber, name, email);
        yield RegisterState.success();
      } catch (e) {
        yield RegisterState.failure(
            isNameValid: nameValid,
            isEmailValid: emailValid,
            isServerError: true);
      }
    } else {
      yield RegisterState.failure(
        isNameValid: nameValid,
        isEmailValid: emailValid,
        isServerError: false,
      );
    }
  }
}
