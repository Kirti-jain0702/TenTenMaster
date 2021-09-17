import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';

class SplashScreenSecondary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(kMainColor),
        ),
      ),
    );
  }
}

class TextOnlyScreen extends StatelessWidget {
  final String text;

  TextOnlyScreen(this.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(text),
      ),
    );
  }
}
