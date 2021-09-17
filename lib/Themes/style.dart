import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///dark theme
final ThemeData darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: kMainTextColor,
  secondaryHeaderColor: kWhiteColor,
  primaryColor: kMainColor,
  bottomAppBarColor: kMainTextColor,
  dividerColor: Color(0x1f000000),
  disabledColor: kDisabledColor,
  buttonColor: kMainColor,
  cardColor: Color(0xff212321),
  hintColor: kLightTextColor,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: kMainColor,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(kMainColor))),
  indicatorColor: kMainColor,
  accentColor: kMainColor,
  bottomAppBarTheme: BottomAppBarTheme(color: kMainColor),
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.normal,
    height: 33,
    padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        side: BorderSide(color: kMainColor)),
    alignedDropdown: false,
    buttonColor: kMainColor,
    disabledColor: kDisabledColor,
  ),
  appBarTheme: AppBarTheme(
    color: kTransparentColor,
    elevation: 0.0,
  ),
  //text theme which contains all text styles
  textTheme: TextTheme(
    //text style of 'Delivering almost everything' at phone_number page
    bodyText1: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18.3,
    ),

    //text style of 'Everything.' at phone_number page
    bodyText2: TextStyle(
      fontSize: 18.3,
      letterSpacing: 1.0,
      color: kDisabledColor,
    ),

    //text style of button at phone_number page
    button: TextStyle(
      fontSize: 13.3,
      color: kWhiteColor,
    ),

    //text style of 'Got Delivered' at home page
    headline4: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16.7,
    ),

    //text style of we'll send verification code at register page
    headline6: TextStyle(
      color: kLightTextColor,
      fontSize: 13.3,
    ),

    //text style of 'everything you need' at home page
    headline5: TextStyle(
      color: kDisabledColor,
      fontSize: 20.0,
      letterSpacing: 0.5,
    ),

    //text entry text style
    caption: TextStyle(
      color: Colors.white,
      fontSize: 13.3,
    ),

    overline: TextStyle(color: kLightTextColor, letterSpacing: 0.2),

    //text style of titles of card at home page
    headline2: TextStyle(
      color: Colors.white,
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
    subtitle2: TextStyle(
      color: kLightTextColor,
      fontSize: 15.0,
    ),
  ).apply(fontFamily: 'GoogleSans'),
);

///light theme
final ThemeData appTheme = ThemeData(
  fontFamily: 'GoogleSans',
  scaffoldBackgroundColor: Colors.white,
  secondaryHeaderColor: kMainTextColor,
  primaryColor: kMainColor,
  bottomAppBarColor: kWhiteColor,
  dividerColor: Color(0x1f000000),
  disabledColor: kDisabledColor,
  buttonColor: kMainColor,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: kMainColor,
  ),
  cardColor: kCardBackgroundColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(kMainColor))),
  hintColor: kLightTextColor,
  indicatorColor: kMainColor,
  accentColor: kMainColor,
  bottomAppBarTheme: BottomAppBarTheme(color: kMainColor),
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.normal,
    height: 33,
    padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        side: BorderSide(color: kMainColor)),
    alignedDropdown: false,
    buttonColor: kMainColor,
    disabledColor: kDisabledColor,
  ),
  appBarTheme: AppBarTheme(
    color: kTransparentColor,
    elevation: 0.0,
    iconTheme: IconThemeData(
      color: Colors.black
    ),
    textTheme: TextTheme(
      headline6: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)
    ).apply(displayColor: Colors.black, bodyColor: Colors.black)
  ),
  //text theme which contains all text styles
  textTheme: TextTheme(
    //text style of 'Delivering almost everything' at phone_number page
    bodyText1: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18.3,
    ),

    //text style of 'Everything.' at phone_number page
    bodyText2: TextStyle(
      fontSize: 18.3,
      letterSpacing: 1.0,
      color: kDisabledColor,
    ),

    //text style of button at phone_number page
    button: TextStyle(
      fontSize: 13.3,
      color: kWhiteColor,
    ),

    //text style of 'Got Delivered' at home page
    headline4: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 16.7,
    ),

    //text style of we'll send verification code at register page
    headline6: TextStyle(
      color: kLightTextColor,
      fontSize: 13.3,
    ),

    //text style of 'everything you need' at home page
    headline5: TextStyle(
      color: kDisabledColor,
      fontSize: 20.0,
      letterSpacing: 0.5,
    ),

    //text entry text style
    caption: TextStyle(
      color: kMainTextColor,
      fontSize: 13.3,
    ),

    overline: TextStyle(color: kLightTextColor, letterSpacing: 0.2),

    //text style of titles of card at home page
    headline2: TextStyle(
      color: kMainTextColor,
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
    subtitle2: TextStyle(
      color: kLightTextColor,
      fontSize: 15.0,
    ),
  ),
);

//text style of continue bottom bar
final TextStyle bottomBarTextStyle = TextStyle(
  fontSize: 15.0,
  color: kWhiteColor,
  fontWeight: FontWeight.w400,
  fontFamily: 'GoogleSans',
);

//text style of text input and account page list
final TextStyle inputTextStyle = TextStyle(
  fontSize: 20.0,
  color: Colors.black,
  fontFamily: 'GoogleSans',
);

final TextStyle listTitleTextStyle = TextStyle(
  fontSize: 16.7,
  fontWeight: FontWeight.bold,
  color: kMainColor,
  fontFamily: 'GoogleSans',
);

final TextStyle orderMapAppBarTextStyle = TextStyle(
  fontSize: 13.3,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  fontFamily: 'GoogleSans',
);

final ColorFilter invertColor = ColorFilter.matrix([
  -1, //RED
  0,
  0,
  0,
  255, //GREEN
  0,
  -1,
  0,
  0,
  255, //BLUE
  0,
  0,
  -1,
  0,
  255, //ALPHA
  0,
  0,
  0,
  1,
  0,
]);
