import 'dart:convert';

import 'package:delivoo/JsonFiles/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static List<Setting> _settings;
  static String currencyIcon = "\$";
  static String distanceMetric,
      privacyPolicy,
      terms,
      taxInPercent,
      deliveryFee,
      deliveryDistance,
      deliveryFeePerKmCharge;

  static Future<void> saveSettings(List<Setting> settings) async {
    _settings = settings;
    await setupBase();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('settings_all', jsonEncode(settings));
  }

  static Future<String> getSettingValue(String forKey) async {
    String toReturn = "";
    if (_settings == null) {
      final prefs = await SharedPreferences.getInstance();
      String settingVal = prefs.getString('settings_all');
      if (settingVal != null && settingVal.isNotEmpty) {
        _settings = (json.decode(settingVal) as List)
            .map((e) => Setting.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _settings = [];
      }
    }
    for (Setting setting in _settings) {
      if (setting.key == forKey) {
        toReturn = setting.value;
        break;
      }
    }
    if (toReturn.isEmpty) {
      print(
          "getSettingValue returned empty value for: $forKey, when settings were: $_settings");
    }
    return toReturn;
  }

  static Future<bool> setupBase() async {
    currencyIcon = await getSettingValue("currency_icon");
    distanceMetric = await getSettingValue("distance_metric");
    privacyPolicy = await getSettingValue("privacy_policy");
    terms = await getSettingValue("terms");
    taxInPercent = await getSettingValue("tax_in_percent");
    deliveryFee = await getSettingValue("delivery_fee");
    deliveryDistance = await getSettingValue("delivery_distance");
    deliveryFeePerKmCharge =
        await getSettingValue("delivery_fee_per_km_charge");
    return currencyIcon != null && currencyIcon.isNotEmpty;
  }

  static double setupNumber(String numString) {
    double toReturn = 0;
    try {
      toReturn = double.parse(numString);
    } catch (e) {
      print(e);
    }
    return toReturn;
  }
}
