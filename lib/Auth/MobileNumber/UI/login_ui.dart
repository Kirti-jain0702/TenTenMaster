import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:delivoo/AppConfig/app_config.dart';
import 'package:delivoo/Components/entry_field.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:flutter/material.dart';

import 'login_interactor.dart';

class LoginUI extends StatefulWidget {
  final LoginInteractor loginPageInteractor;

  LoginUI(this.loginPageInteractor);

  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  TextEditingController _controller = TextEditingController();
  String phoneName = "+91";
  String isoCode = "IN";


  @override
  void initState() {
    if (AppConfig.isDemoMode) {
      isoCode = "IN";
      _controller.text = "9898989898";

      Future.delayed(
          Duration(seconds: 1),
          () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context).demo_login_title),
                  content:
                      Text(AppLocalizations.of(context).demo_login_message),
                  actions: <Widget>[
                    MaterialButton(
                      child: Text(AppLocalizations.of(context).okay),
                      textColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Theme.of(context).backgroundColor)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                );
              }));
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var locale = AppLocalizations.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        //used for scrolling when keyboard pops up
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset("images/logos/logo_user.png"),
                ),
              ),
              Image.asset("images/logos/Delivery.gif"),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: <Widget>[
                 /*   CountryCodePicker(
                      onChanged: (value) {
                        isoCode = value.code;
                      },
                      builder: (value) => Padding(
                        padding: EdgeInsets.only(bottom: 7.0),
                        child: Text(
                          '$value',
                          style: theme.textTheme.subtitle2
                              .copyWith(color: theme.secondaryHeaderColor),
                        ),
                      ),
                      initialSelection: AppConfig.isDemoMode ? '+91' : '+1',
                      textStyle: theme.textTheme.caption,
                      showFlag: false,
                      showFlagDialog: true,
                      favorite: ['+91', 'US'],
                    ),*/
                    GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: true,
                          //countryFilter: ['IN','US','SG'],
                            FavCountries: ['IN','US','SG'],
                          countryListTheme: CountryListThemeData(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16))),
                          onSelect: (country) {
                            setState(() {
                              isoCode = country.countryCode.toUpperCase();
                              phoneName = "+" + country.phoneCode;
                            });
                          },
                        );
                      },
                      child: SizedBox(
                        height: 26,
                        child: Text(
                          phoneName,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.subtitle2
                              .copyWith(color: theme.secondaryHeaderColor),
                        ),
                      ),
                    ),

                    //takes phone number as input
                    Expanded(
                      child: EntryField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        readOnly: false,
                        hint: locale.mobileText,
                        border: InputBorder.none,
                      ),
                    ),
                    ElevatedButton(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          locale.continueText,
                          style: theme.textTheme.button,
                        ),
                      ),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      onPressed: () => widget.loginPageInteractor
                          .loginWithMobile(isoCode, _controller.text),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 32.0,
                  color: theme.cardColor,
                  child: Center(
                    child: Text(
                      locale.or,
                      style: theme.textTheme.bodyText2,
                    ),
                  ),
                ),
              ),
              SocialLoginButton(
                locale.facebook,
                Color(0xff3a559f),
                'images/ic_login_facebook.png',
                () => widget.loginPageInteractor.loginWithFacebook(),
              ),
              SocialLoginButton(
                locale.google,
                theme.scaffoldBackgroundColor,
                'images/ic_login_google.png',
                () => widget.loginPageInteractor.loginWithGoogle(),
              ),
              if (Platform.isIOS)
                SocialLoginButton(
                  locale.apple,
                  theme.secondaryHeaderColor,
                  'images/ic_login_apple.png',
                  () => widget.loginPageInteractor.loginWithApple(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final String text;
  final Color color;
  final String image;
  final Function onTap;

  SocialLoginButton(this.text, this.color, this.image, this.onTap);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var isGoogle = text == AppLocalizations.of(context).google;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50.0,
        color: color,
        child: Row(
          children: [
            Spacer(),
            Image.asset(
              image,
              height: 19.0,
              width: 19.7,
            ),
            SizedBox(
              width: 34.0,
            ),
            Text(AppLocalizations.of(context).continueWith,
                style: theme.textTheme.caption.copyWith(
                    color: isGoogle
                        ? theme.secondaryHeaderColor
                        : theme.scaffoldBackgroundColor)),
            Text(text,
                style: theme.textTheme.caption.copyWith(
                    color: isGoogle
                        ? theme.secondaryHeaderColor
                        : theme.scaffoldBackgroundColor,
                    fontWeight: FontWeight.bold)),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
