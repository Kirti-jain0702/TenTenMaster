import 'package:delivoo/Auth/AuthRepo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'social_event.dart';
import 'social_state.dart';

class SocialLoginBloc extends Bloc<SocialLoginEvent, SocialLoginState> {
  AuthRepo _userRepository = AuthRepo();

  SocialLoginBloc() : super(SocialLoginState.initial());

  @override
  Stream<SocialLoginState> mapEventToState(SocialLoginEvent event) async* {
    if (event is LoginWithFacebookPressed) {
      yield* _mapLoginWithFacebookPressedToState();
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    }
  }

  Stream<SocialLoginState> _mapLoginWithGooglePressedToState() async* {
    yield SocialLoginState.loading();
    try {
      bool isRegistered = await _userRepository.signInWithGoogle();

      yield SocialLoginState.successOf(isRegistered: isRegistered);
    } catch (_) {
      print('error: ' + _.toString());

      yield SocialLoginState.failure();
    }
  }

  Stream<SocialLoginState> _mapLoginWithFacebookPressedToState() async* {
    try {
      bool isRegistered = await _userRepository.signInWithFacebook();

      yield SocialLoginState.successOf(isRegistered: isRegistered);
    } catch (_) {
      await _userRepository.logout();
      yield SocialLoginState.failure();
    }
  }
}
