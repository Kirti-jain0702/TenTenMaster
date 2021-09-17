import 'package:delivoo/Auth/login_navigator.dart';
import 'package:delivoo/Cart/offers_page.dart';
import 'package:delivoo/HomeOrderAccount/Account/UI/ListItems/add_money_page.dart';
import 'package:delivoo/HomeOrderAccount/Account/UI/ListItems/saved_addresses_page.dart';
import 'package:delivoo/HomeOrderAccount/Account/UI/ListItems/settings_page.dart';
import 'package:delivoo/HomeOrderAccount/Account/UI/ListItems/support_page.dart';
import 'package:delivoo/HomeOrderAccount/Account/UI/ListItems/tnc_page.dart';
import 'package:delivoo/HomeOrderAccount/Account/UI/ListItems/wallet_page.dart';
import 'package:delivoo/HomeOrderAccount/Account/UI/account_page.dart';
import 'package:delivoo/HomeOrderAccount/Home/UI/home_page.dart';
import 'package:delivoo/HomeOrderAccount/Home/UI/order_info_page.dart';
import 'package:delivoo/HomeOrderAccount/Home/checkout_navigator.dart';
import 'package:delivoo/HomeOrderAccount/Order/UI/list_of_order_page.dart';
import 'package:delivoo/HomeOrderAccount/Order/UI/rate_now_page.dart';
import 'package:delivoo/Maps/UI/location_page.dart';
import 'package:delivoo/ReviewPage/reviews_page.dart';
import 'package:flutter/material.dart';

class PageRoutes {
  static const String locationPage = 'location_page';
  static const String homePage = 'home_page';
  static const String accountPage = 'account_page';
  static const String orderPage = 'order_page';
  static const String items = 'items';
  static const String tncPage = 'tnc_page';
  static const String savedAddressesPage = 'saved_addresses_page';
  static const String supportPage = 'support_page';
  static const String loginNavigator = 'login_navigator';
  static const String orderInfoPage = 'order_info_page';
  static const String wallet = 'wallet_page';
  static const String addMoney = 'addMoney_page';
  static const String settings = 'settings_page';
  static const String review = 'reviews';
  static const String checkout = 'checkout';
  static const String rateNow = 'rate_now';
  static const String offersPage = 'offers_page';

  Map<String, WidgetBuilder> routes() {
    return {
      locationPage: (context) => LocationPage(),
      homePage: (context) => HomePage(),
      orderPage: (context) => OrderPage(),
      accountPage: (context) => AccountPage(),
      tncPage: (context) => TncPage(),
      savedAddressesPage: (context) => SavedAddressesPage(),
      supportPage: (context) => SupportPage(),
      loginNavigator: (context) => LoginNavigator(),
      orderInfoPage: (context) => OrderInfoPage(),
      wallet: (context) => WalletPage(),
      addMoney: (context) => AddMoneyPage(),
      settings: (context) => SettingsPage(),
      review: (context) => ReviewPage(),
      checkout: (context) => CheckoutNavigator(),
      rateNow: (context) => RateNowPage(),
      offersPage: (context) => OffersPage(),
    };
  }
}
