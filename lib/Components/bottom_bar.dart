import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/Themes/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final Function onTap;
  final String text;
  final Color color;
  final Color textColor;

  BottomBar(
      {@required this.onTap, @required this.text, this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Center(
          child: Text(
            text,
            style: bottomBarTextStyle.copyWith(color: textColor) ??
                bottomBarTextStyle,
          ),
        ),
        color: color ?? kMainColor,
        height: 60.0,
      ),
    );
  }
}
