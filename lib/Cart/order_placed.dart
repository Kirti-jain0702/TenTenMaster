import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';

class OrderPlaced extends StatelessWidget {
  final VoidCallback onShowOrdersPagePressed;

  OrderPlaced(this.onShowOrdersPagePressed);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Spacer(),
          Expanded(
            child: Image.asset(
              'images/order_placed.png',
              height: 265.7,
              width: 260.7,
            ),
          ),
          Text(
            AppLocalizations.of(context).placed,
            style:
                Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 23.3),
          ),
          Text(
            AppLocalizations.of(context).thanks,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(color: kDisabledColor, fontWeight: FontWeight.w400),
          ),
          Spacer(flex: 1),
          BottomBar(
            text: AppLocalizations.of(context).orderText,
            onTap: onShowOrdersPagePressed,
          )
        ],
      ),
    );
  }
}
