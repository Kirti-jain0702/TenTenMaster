import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';

class AddressIcon extends StatelessWidget {
  final String address;

  AddressIcon(this.address);

  @override
  Widget build(BuildContext context) {
    if (address == 'Home') {
      return CircleAvatar(
        radius: 30,
        backgroundColor: kCardBackgroundColor,
        child: ImageIcon(
          AssetImage('images/address/ic_homeblk.png'),
          color: kMainColor,
          size: 28,
        ),
      );
    } else if (address == 'Office') {
      return CircleAvatar(
        radius: 30,
        backgroundColor: kCardBackgroundColor,
        child: ImageIcon(
          AssetImage('images/address/ic_officeblk.png'),
          color: kMainColor,
          size: 28,
        ),
      );
    } else {
      return CircleAvatar(
        radius: 30,
        backgroundColor: kCardBackgroundColor,
        child: ImageIcon(
          AssetImage('images/address/ic_otherblk.png'),
          color: kMainColor,
          size: 28,
        ),
      );
    }
  }
}
