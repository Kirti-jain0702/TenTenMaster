import 'package:delivoo/AppConfig/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(Locale(AppConfig.languageDefault));

  void localeSelected(String key) {
    emit(Locale(key));
  }

  getCurrentLanguage() async {
    var prefs = await SharedPreferences.getInstance();
    localeSelected(prefs.containsKey('locale')
        ? prefs.getString('locale')
        : AppConfig.languageDefault);
  }

  Future<String> getCurrentLanguageVal() async {
    var prefs = await SharedPreferences.getInstance();

    return Future.value(prefs.containsKey('locale')
        ? prefs.getString('locale')
        : AppConfig.languageDefault);
  }

  setCurrentLanguage(String langCode, bool save) async {
    if (save) {
      var prefs = await SharedPreferences.getInstance();
      await prefs.setString('locale', langCode);
    }
    localeSelected(langCode);
  }
}
