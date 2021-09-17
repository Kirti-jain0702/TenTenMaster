import 'package:delivoo/Themes/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeData> {
  final bool isDark;

  ThemeCubit(this.isDark)
      : super(isDark == null
            ? appTheme
            : isDark
                ? darkTheme
                : appTheme);

  void selectLightTheme() {
    setTheme(false);
    emit(appTheme);
  }

  void selectDarkTheme() {
    setTheme(true);
    emit(darkTheme);
  }

  Future<void> setTheme(bool isDark) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
  }

  Future<bool> getTheme() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDark');
  }
}
