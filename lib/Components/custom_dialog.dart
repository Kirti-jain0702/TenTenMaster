import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Routes/routes.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showCustomDialog(BuildContext context, {String title, String content}) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(title ?? AppLocalizations.of(context).noLoginText),
      content: Text(content ?? AppLocalizations.of(context).loginText),
      actions: <Widget>[
        FlatButton(
          child: Text(AppLocalizations.of(context).no),
          textColor: kMainColor,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: kTransparentColor)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
            child: Text(AppLocalizations.of(context).okay),
            shape: RoundedRectangleBorder(
                side: BorderSide(color: kTransparentColor)),
            textColor: kMainColor,
            onPressed: () {
              // Navigator.pop(context);
              Navigator.popAndPushNamed(context, PageRoutes.loginNavigator);
            })
      ],
    ),
  );
}
