import 'dart:async';

import 'package:delivoo/AppConfig/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String getTranslationOf(String key) {
    return AppConfig.languagesSupported[locale.languageCode].values[key] != null
        ? AppConfig.languagesSupported[locale.languageCode].values[key]
        : AppConfig.languagesSupported[AppConfig.languageDefault].values[key] !=
                null
            ? AppConfig
                .languagesSupported[AppConfig.languageDefault].values[key]
            : key;
  }

  static List<Locale> getSupportedLocales() {
    List<Locale> toReturn = [];
    for (String langCode in AppConfig.languagesSupported.keys)
      toReturn.add(Locale(langCode));
    return toReturn;
  }

  String get vegetableText {
    return getTranslationOf("vegetableText");
  }

  String get foodText {
    return getTranslationOf("foodText");
  }

  String get meatText {
    return getTranslationOf("meatText");
  }

  String get youAreAlmost {
    return getTranslationOf("youAreAlmost");
  }

  String get medicineText {
    return getTranslationOf("medicineText");
  }

  String get petText {
    return getTranslationOf("petText");
  }

  String get customText {
    return getTranslationOf("customText");
  }

  String get invalidNumber {
    return getTranslationOf("invalidNumber");
  }

  String get networkError {
    return getTranslationOf("networkError");
  }

  String get register {
    return getTranslationOf("register");
  }

  String get invalidName {
    return getTranslationOf("invalidName");
  }

  String get invalidEmail {
    return getTranslationOf("invalidEmail");
  }

  String get invalidNameAndEmail {
    return getTranslationOf("invalidNameAndEmail");
  }

  String get fullName {
    return getTranslationOf("fullName");
  }

  String get emailAddress {
    return getTranslationOf("emailAddress");
  }

  String get mobileNumber {
    return getTranslationOf("mobileNumber");
  }

  String get verificationText {
    return getTranslationOf("verificationText");
  }

  String get verification {
    return getTranslationOf("verification");
  }

  String get checkNetwork {
    return getTranslationOf("checkNetwork");
  }

  String get invalidOTP {
    return getTranslationOf("invalidOTP");
  }

  String get enterVerification {
    return getTranslationOf("enterVerification");
  }

  String get verificationCode {
    return getTranslationOf("verificationCode");
  }

  String get resend {
    return getTranslationOf("resend");
  }

  String get offlineText {
    return getTranslationOf("resend");
  }

  String get onlineText {
    return getTranslationOf("resend");
  }

  String get goOnline {
    return getTranslationOf("resend");
  }

  String get goOffline {
    return getTranslationOf("resend");
  }

  String get orders {
    return getTranslationOf("orders");
  }

  String get ride {
    return getTranslationOf("ride");
  }

  String get earnings {
    return getTranslationOf("earnings");
  }

  String get location {
    return getTranslationOf("earnings");
  }

  String get grant {
    return getTranslationOf("earnings");
  }

  String get homeText1 {
    return getTranslationOf("homeText1");
  }

  String get homeText2 {
    return getTranslationOf("homeText2");
  }

  String get bodyText1 {
    return getTranslationOf("bodyText1");
  }

  String get bodyText2 {
    return getTranslationOf("bodyText2");
  }

  String get mobileText {
    return getTranslationOf("mobileText");
  }

  String get continueText {
    return getTranslationOf("continueText");
  }

  String get tnc {
    return getTranslationOf("tnc");
  }

  String get support {
    return getTranslationOf("support");
  }

  String get aboutUs {
    return getTranslationOf("aboutUs");
  }

  String get login {
    return getTranslationOf("login");
  }

  String get noLoginText {
    return getTranslationOf("noLoginText");
  }

  String get logout {
    return getTranslationOf("logout");
  }

  String get loggingOut {
    return getTranslationOf("loggingOut");
  }

  String get areYouSure {
    return getTranslationOf("areYouSure");
  }

  String get yes {
    return getTranslationOf("yes");
  }

  String get okay {
    return getTranslationOf("okay");
  }

  String get no {
    return getTranslationOf("no");
  }

  String get aboutDelivoo {
    return getTranslationOf("aboutDelivoo");
  }

  String get saved {
    return getTranslationOf("saved");
  }

  String get savedText {
    return getTranslationOf("savedText");
  }

  String get notLogin {
    return getTranslationOf("notLogin");
  }

  String get loginText {
    return getTranslationOf("loginText");
  }

  String get aboutBody {
    return getTranslationOf("aboutBody");
  }

  String get ourVision {
    return getTranslationOf("ourVision");
  }

  String get companyPolicy {
    return getTranslationOf("companyPolicy");
  }

  String get termsOfUse {
    return getTranslationOf("termsOfUse");
  }

  String get message {
    return getTranslationOf("message");
  }

  String get enterMessage {
    return getTranslationOf("enterMessage");
  }

  String get orWrite {
    return getTranslationOf("orWrite");
  }

  String get yourWords {
    return getTranslationOf("yourWords");
  }

  String get online {
    return getTranslationOf("online");
  }

  String get recent {
    return getTranslationOf("recent");
  }

  String get vegetable {
    return getTranslationOf("vegetable");
  }

  String get upload {
    return getTranslationOf("upload");
  }

  String get updateInfo {
    return getTranslationOf("updateInfo");
  }

  String get instruction {
    return getTranslationOf("instruction");
  }

  String get cod {
    return getTranslationOf("cod");
  }

  String get backToHome {
    return getTranslationOf("backToHome");
  }

  String get viewEarnings {
    return getTranslationOf("viewEarnings");
  }

  String get yourEarnings {
    return getTranslationOf("yourEarnings");
  }

  String get youDrived {
    return getTranslationOf("youDrived");
  }

  String get viewOrderInfo {
    return getTranslationOf("viewOrderInfo");
  }

  String get delivered {
    return getTranslationOf("delivered");
  }

  String get thankYou {
    return getTranslationOf("thankYou");
  }

  String get newDeliveryTask {
    return getTranslationOf("newDeliveryTask");
  }

  String get orderInfo {
    return getTranslationOf("orderInfo");
  }

  String get close {
    return getTranslationOf("close");
  }

  String get direction {
    return getTranslationOf("direction");
  }

  String get store {
    return getTranslationOf("store");
  }

  String get markPicked {
    return getTranslationOf("markPicked");
  }

  String get markDelivered {
    return getTranslationOf("markDelivered");
  }

  String get acceptDelivery {
    return getTranslationOf("acceptDelivery");
  }

  String get address {
    return getTranslationOf("address");
  }

  String get storeAddress {
    return getTranslationOf("storeAddress");
  }

  String get search {
    return getTranslationOf("search");
  }

  String get onion {
    return getTranslationOf("onion");
  }

  String get tomato {
    return getTranslationOf("tomato");
  }

  String get cauliflower {
    return getTranslationOf("cauliflower");
  }

  String get add {
    return getTranslationOf("add");
  }

  String get viewCart {
    return getTranslationOf("viewCart");
  }

  String get confirm {
    return getTranslationOf("confirm");
  }

  String get selectPayment {
    return getTranslationOf("selectPayment");
  }

  String get amount {
    return getTranslationOf("amount");
  }

  String get card {
    return getTranslationOf("card");
  }

  String get credit {
    return getTranslationOf("credit");
  }

  String get debit {
    return getTranslationOf("debit");
  }

  String get cash {
    return getTranslationOf("cash");
  }

  String get paypal {
    return getTranslationOf("paypal");
  }

  String get payU {
    return getTranslationOf("payU");
  }

  String get stripe {
    return getTranslationOf("stripe");
  }

  String get setLocation {
    return getTranslationOf("setLocation");
  }

  String get enterLocation {
    return getTranslationOf("enterLocation");
  }

  String get saveAddress {
    return getTranslationOf("saveAddress");
  }

  String get addressLabel {
    return getTranslationOf("addressLabel");
  }

  String get addNew {
    return getTranslationOf("addNew");
  }

  String get submit {
    return getTranslationOf("submit");
  }

  String get change {
    return getTranslationOf("change");
  }

  String get pay {
    return getTranslationOf("pay");
  }

  String get deliver {
    return getTranslationOf("deliver");
  }

  String get service {
    return getTranslationOf("service");
  }

  String get discount {
    return getTranslationOf("discount");
  }

  String get sub {
    return getTranslationOf("sub");
  }

  String get paymentInfo {
    return getTranslationOf("paymentInfo");
  }

  String get pickup {
    return getTranslationOf("pickup");
  }

  String get process {
    return getTranslationOf("process");
  }

  String get custom {
    return getTranslationOf("custom");
  }

  String get storeFound {
    return getTranslationOf("storeFound");
  }

  String get send {
    return getTranslationOf("send");
  }

  String get pickupText {
    return getTranslationOf("pickupText");
  }

  String get pickupAddress {
    return getTranslationOf("pickupAddress");
  }

  String get dropText {
    return getTranslationOf("dropText");
  }

  String get drop {
    return getTranslationOf("drop");
  }

  String get packageText {
    return getTranslationOf("packageText");
  }

  String get package {
    return getTranslationOf("package");
  }

  String get deliveryCharge {
    return getTranslationOf("deliveryCharge");
  }

  String get done {
    return getTranslationOf("done");
  }

  String get vegetables {
    return getTranslationOf("vegetables");
  }

  String get fruits {
    return getTranslationOf("fruits");
  }

  String get herbs {
    return getTranslationOf("herbs");
  }

  String get dairy {
    return getTranslationOf("dairy");
  }

  String get paperDocuments {
    return getTranslationOf("paperDocuments");
  }

  String get flowersChocolates {
    return getTranslationOf("flowersChocolates");
  }

  String get sports {
    return getTranslationOf("sports");
  }

  String get clothes {
    return getTranslationOf("clothes");
  }

  String get electronic {
    return getTranslationOf("electronic");
  }

  String get household {
    return getTranslationOf("household");
  }

  String get glass {
    return getTranslationOf("glass");
  }

  String get or {
    return getTranslationOf("or");
  }

  String get continueWith {
    return getTranslationOf("continueWith");
  }

  String get facebook {
    return getTranslationOf("facebook");
  }

  String get google {
    return getTranslationOf("google");
  }

  String get apple {
    return getTranslationOf("apple");
  }

  String get wallet {
    return getTranslationOf("wallet");
  }

  String get settings {
    return getTranslationOf("settings");
  }

  String get availableBalance {
    return getTranslationOf("availableBalance");
  }

  String get addMoney {
    return getTranslationOf("addMoney");
  }

  String get accountHolderName {
    return getTranslationOf("accountHolderName");
  }

  String get bankName {
    return getTranslationOf("bankName");
  }

  String get branchCode {
    return getTranslationOf("branchCode");
  }

  String get accountNumber {
    return getTranslationOf("accountNumber");
  }

  String get enterAmountToTransfer {
    return getTranslationOf("enterAmountToTransfer");
  }

  String get bankInfo {
    return getTranslationOf("bankInfo");
  }

  String get display {
    return getTranslationOf("display");
  }

  String get darkMode {
    return getTranslationOf("darkMode");
  }

  String get darkText {
    return getTranslationOf("darkText");
  }

  String get selectLanguage {
    return getTranslationOf("language");
  }

  String get name1 {
    return getTranslationOf("name1");
  }

  String get name2 {
    return getTranslationOf("name2");
  }

  String get content1 {
    return getTranslationOf("content1");
  }

  String get content2 {
    return getTranslationOf("content2");
  }

  String get past {
    return getTranslationOf("past");
  }

  String get rate {
    return getTranslationOf("rate");
  }

  String get deliv {
    return getTranslationOf("deliv");
  }

  String get how {
    return getTranslationOf("how");
  }

  String get withR {
    return getTranslationOf("withR");
  }

  String get addReview {
    return getTranslationOf("addReview");
  }

  String get writeReview {
    return getTranslationOf("writeReview");
  }

  String get feedback {
    return getTranslationOf("feedback");
  }

  String get hey {
    return getTranslationOf("hey");
  }

  String get lightText {
    return getTranslationOf("lightText");
  }

  String get lightMode {
    return getTranslationOf("lightMode");
  }

  String get cancel {
    return getTranslationOf("cancel");
  }

  String get demo_login_title {
    return getTranslationOf("demo_login_title");
  }

  String get demo_login_message {
    return getTranslationOf("demo_login_message");
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppConfig.languagesSupported.keys.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of AppLocalizations.
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
