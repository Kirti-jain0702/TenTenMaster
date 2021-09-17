import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';

class AddressTypeButton extends StatelessWidget {
  final String label;
  final String image;
  final Function onPressed;
  final bool isSelected;
  final Color selectedColor = Colors.white;
  final Color unSelectedColor = Colors.black;

  AddressTypeButton({this.label, this.image, this.onPressed, this.isSelected});

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onPressed: onPressed,
      icon: Image.asset(
        image,
        scale: 3.5,
        color: isSelected ? selectedColor : unSelectedColor,
      ),
      label: Text(label),
      textColor: isSelected ? selectedColor : unSelectedColor,
      color: isSelected ? kMainColor : Theme.of(context).cardColor,
    );
  }
}
