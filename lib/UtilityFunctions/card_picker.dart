import 'dart:convert';

import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Components/entry_field.dart';
import 'package:delivoo/Components/show_toast.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardPicker {
  static Future<dynamic> pickCard(BuildContext context,
      [CardInfo cardInfo, bool saveCardInfo]) {
    TextEditingController _nameController = TextEditingController(
        text: cardInfo != null && cardInfo.cardName != null
            ? cardInfo.cardName
            : "");
    TextEditingController _numberController = TextEditingController(
        text: cardInfo != null && cardInfo.cardNumber != null
            ? cardInfo.cardNumber
            : "");
    TextEditingController _monthController = TextEditingController(
        text: cardInfo != null && cardInfo.cardMonth != null
            ? cardInfo.cardMonth.toString()
            : "");
    TextEditingController _yearController = TextEditingController(
        text: cardInfo != null && cardInfo.cardYear != null
            ? cardInfo.cardYear.toString()
            : "");
    TextEditingController _cvcController = TextEditingController(
        text: cardInfo != null && cardInfo.cardCvv != null
            ? cardInfo.cardCvv.toString()
            : "");
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(
                AppLocalizations.of(context)
                    .getTranslationOf("card_info")
                    .toUpperCase(),
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.67,
                    color: kHintColor),
              ),
              children: [
                EntryField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  label: AppLocalizations.of(context)
                      .getTranslationOf("card_name"),
                ),
                EntryField(
                  controller: _numberController,
                  label: AppLocalizations.of(context)
                      .getTranslationOf("card_number"),
                  keyboardType: TextInputType.number,
                ),
                EntryField(
                  controller: _monthController,
                  label: AppLocalizations.of(context)
                      .getTranslationOf("card_exp_month"),
                  keyboardType: TextInputType.number,
                ),
                EntryField(
                  controller: _yearController,
                  label: AppLocalizations.of(context)
                      .getTranslationOf("card_exp_year"),
                  keyboardType: TextInputType.number,
                ),
                EntryField(
                  controller: _cvcController,
                  label:
                      AppLocalizations.of(context).getTranslationOf("card_cvv"),
                  keyboardType: TextInputType.number,
                ),
                BottomBar(
                    onTap: () async {
                      int month = int.parse(_monthController.text);
                      var year = int.parse(_yearController.text);
                      if (month > 12 && month < 1) {
                        showToast(AppLocalizations.of(context)
                            .getTranslationOf("card_invalid_month"));
                      } else if (year < DateTime.now().year) {
                        showToast(AppLocalizations.of(context)
                            .getTranslationOf("card_invalid_year"));
                      } else if (_numberController.text.length < 10) {
                        showToast(AppLocalizations.of(context)
                            .getTranslationOf("card_invalid_number"));
                      } else if (_nameController.text.isEmpty) {
                        showToast(AppLocalizations.of(context)
                            .getTranslationOf("card_invalid_name"));
                      } else {
                        CardInfo cardInfo = CardInfo(
                          _nameController.text,
                          _numberController.text,
                          month,
                          year,
                          _cvcController.text,
                        );
                        if (saveCardInfo != null && saveCardInfo == true) {
                          await CardInfo.saveCard(cardInfo);
                        }
                        Navigator.pop(context, cardInfo);
                      }
                    },
                    text: AppLocalizations.of(context).continueText)
              ],
            ));
  }

  static Future<CardInfo> getSavedCard() {
    return CardInfo.getCard();
  }
}

class CardInfo {
  final String cardName, cardNumber, cardCvv;
  final int cardMonth, cardYear;

  CardInfo(this.cardName, this.cardNumber, this.cardMonth, this.cardYear,
      this.cardCvv);

  factory CardInfo.fromJson(Map<String, dynamic> json) {
    return CardInfo(
      json['cardName'] as String,
      json['cardNumber'] as String,
      json['cardMonth'] as int,
      json['cardYear'] as int,
      json['cardCvv'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'cardName': cardName,
      'cardNumber': cardNumber,
      'cardMonth': cardMonth,
      'cardYear': cardYear,
      'cardCvv': cardCvv
    };
  }

  static Future<bool> saveCard(CardInfo cardInfo) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('payment_card', jsonEncode(cardInfo));
  }

  static Future<CardInfo> getCard() async {
    CardInfo toReturn;
    final prefs = await SharedPreferences.getInstance();
    String paymentCard = prefs.getString("payment_card");
    if (paymentCard != null) {
      try {
        toReturn = CardInfo.fromJson(jsonDecode(paymentCard));
      } catch (e) {
        print(e);
      }
    }
    return toReturn;
  }
}
