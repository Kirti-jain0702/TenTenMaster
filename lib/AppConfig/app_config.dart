import 'package:delivoo/Locale/arabic.dart';
import 'package:delivoo/Locale/chinese.dart';
import 'package:delivoo/Locale/english.dart';
import 'package:delivoo/Locale/french.dart';
import 'package:delivoo/Locale/italian.dart';

class AppConfig {
  static const String appName = 'Delivoo';
  static const String packageName = 'com.tentendelivery.customer';
  static const String baseUrl = 'https://admin.tentenecom.com/';
  static const String apiKey = 'AIzaSyCgxYlKYfp8dz8JgW5UxIEX--aI8YlPxDw';
  static const String oneSignalId = '96dc5c29-15c6-4700-aafd-788ba7fed508';
  static final String languageDefault = "en";
  static final Map<String, AppLanguage> languagesSupported = {
    'en': AppLanguage("English", englishLocale()),
    'ar': AppLanguage("عربى", arabicLocale()),
    'it': AppLanguage("Italiano", italianLocale()),
    'fr': AppLanguage("Français", frenchLocale()),
    'zh': AppLanguage("中国人", chineseLocale()),
    'ta': AppLanguage("தமிழ்", englishLocale()),
  };
  static const bool enableDistanceCheck = true;
  static const bool isDemoMode = false;
}

class AppLanguage {
  final String name;
  final Map<String, String> values;

  AppLanguage(this.name, this.values);
}
