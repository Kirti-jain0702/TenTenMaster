import 'package:bloc/bloc.dart';
import 'package:delivoo/HomeOrderAccount/ProductRepository/product_repository.dart';
import 'package:delivoo/JsonFiles/settings.dart';
import 'package:delivoo/SettingsBloc/settings_event.dart';
import 'package:delivoo/SettingsBloc/settings_state.dart';
import 'package:delivoo/UtilityFunctions/app_settings.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(LoadingSettingsState());

  ProductRepository _repository = ProductRepository();

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is FetchSettingsEvent) {
      yield LoadingSettingsState();
      try {
        bool setuped = await AppSettings.setupBase();
        if (setuped) yield SuccessSettingsState();
        List<Setting> settings = await _repository.getSettings();
        await AppSettings.saveSettings(settings);
        if (!setuped) yield SuccessSettingsState();
      } catch (e) {
        yield FailureSettingsState(e);
      }
    }
  }
}
