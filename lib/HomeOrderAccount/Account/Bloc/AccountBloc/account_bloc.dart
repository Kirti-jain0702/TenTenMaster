import 'package:bloc/bloc.dart';
import 'package:delivoo/Auth/AuthRepo/auth_repository.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/AccountBloc/account_event.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/AccountBloc/account_state.dart';
import 'package:delivoo/JsonFiles/Auth/Responses/user_info.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AuthRepo _userRepository = AuthRepo();

  AccountBloc() : super(LoadingState());

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is FetchEvent) {
      yield* _mapFetchDataToState();
    } else if (event is UpdateEvent) {
      yield* _mapUpdateDataToState(event);
    }
  }

  Stream<AccountState> _mapFetchDataToState() async* {
    yield LoadingState();
    try {
      UserInformation userInfo = await _userRepository.getUserInfo();
      yield SuccessState(userInfo);
    } catch (e) {
      print(e);
      yield FailureState("something_went_wrong");
    }
  }

  Stream<AccountState> _mapUpdateDataToState(UpdateEvent updateEvent) async* {
    yield LoadingUpdateUserState();
    try {
      UserInformation userInfo =
          await _userRepository.updateInfo(updateEvent.name, updateEvent.image);
      await _userRepository.saveUser(userInfo);
      yield SuccessUpdateUserState(userInfo);
    } catch (e) {
      print(e);
      yield FailureState("something_went_wrong");
    }
  }
}
