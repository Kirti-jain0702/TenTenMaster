import 'package:delivoo/Locale/english.dart';
import 'package:delivoo/Locale/french.dart';
import 'package:delivoo/Locale/italian.dart';
import 'package:delivoo/Locale/arabic.dart';

class AppConfig {
  static const String appName = 'Delivoo';

  /* static const String packageName = 'com.yourapplicationid'; */
  static const String packageName = 'com.tentendelivery.customer';

  /* static const String baseUrl = 'https://www.yourapibase.com/'; */
  static const String baseUrl = 'https://admin.tentenecom.com/';

  static const String apiKey = 'AIzaSyAKTyoE7MKLhl0RepVSm3bmkVQ0rvGoky0';

  static const String oneSignalId = '96dc5c29-15c6-4700-aafd-788ba7fed508';
  static final String languageDefault = "en";
  static final bool enableLoginWithFacebook = false;
  static final bool enableLoginWithGoogle = false;
  static final Map<String, AppLanguage> languagesSupported = {
    'en': AppLanguage("English", englishLocale()),
    'ar': AppLanguage("عربى", arabicLocale()),
    'it': AppLanguage("Italiano", italianLocale()),
    'fr': AppLanguage("Français", frenchLocale())
  };
  static const bool enableDistanceCheck = true;
}

class AppLanguage {
  final String name;
  final Map<String, String> values;

  AppLanguage(this.name, this.values);
}
