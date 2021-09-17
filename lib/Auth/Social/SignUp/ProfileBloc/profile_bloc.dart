import 'package:bloc/bloc.dart';
import 'package:delivoo/Auth/AuthRepo/auth_repository.dart';
import 'package:delivoo/JsonFiles/Auth/Responses/sign_up_response.dart';

import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  AuthRepo _userRepository = AuthRepo();

  ProfileBloc() : super(ProfileState('', ''));

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is FetchProfileEvent) {
      yield* _mapFetchProfileToState();
    }
  }

  Stream<ProfileState> _mapFetchProfileToState() async* {
    bool isSocialSignIn = await _userRepository.isSignedInWithSocial();
    if (isSocialSignIn) {
      SignUpResponse signUpResponse = await _userRepository.getSocialUserInfo();
      yield ProfileState(signUpResponse.name, signUpResponse.email);
    } else {
      throw Exception();
    }
  }
}
