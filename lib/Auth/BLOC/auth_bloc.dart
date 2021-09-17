import 'package:delivoo/Auth/AuthRepo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepo _userRepository = AuthRepo();

  AuthBloc() : super(Uninitialized());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    bool isSignedIn = await _userRepository.isSignedIn();
    if (isSignedIn) {
      yield Authenticated();
    } else {
      yield Unauthenticated();
    }
  }

  AuthState _mapLoggedInToState() {
    return Authenticated();
  }

  Stream<AuthState> _mapLoggedOutToState() async* {
    await _userRepository.logout();
    yield RestartState();
  }
}
