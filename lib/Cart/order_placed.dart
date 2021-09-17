import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Components/show_toast.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CartQuantityBloc/cart_quantity_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CartQuantityBloc/cart_quantity_event.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Payment/PaymentBloc/payment_bloc.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPlaced extends StatelessWidget {
  final PaymentStatus paymentStatus;
  final Function onShowOrdersPagePressed;

  OrderPlaced(this.paymentStatus, this.onShowOrdersPagePressed);

  Future<void> processPaymentStatus(BuildContext context) async {
    if (paymentStatus.isPaid) {
      var prefs = await SharedPreferences.getInstance();
      prefs.remove("cart_products");
      BlocProvider.of<CartQuantityBloc>(context)
          .add(UpdateCartQuantityEvent(0));
    }
    if (paymentStatus.paidVia != "cod") {
      showToast(AppLocalizations.of(context).getTranslationOf(
          paymentStatus.isPaid ? "payment_success" : "payment_fail"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: processPaymentStatus(context),
        builder: (ctx, snapshot) {
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
                  AppLocalizations.of(context).getTranslationOf(
                      paymentStatus.isPaid ? "order_placed" : "order_failed"),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 23.3),
                ),
                Text(
                  AppLocalizations.of(context).getTranslationOf(
                      paymentStatus.isPaid
                          ? "order_placed_msg"
                          : "order_failed_msg"),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: kDisabledColor, fontWeight: FontWeight.w400),
                ),
                Spacer(flex: 1),
                BottomBar(
                  text: AppLocalizations.of(context).getTranslationOf(
                      paymentStatus.isPaid ? "my_orders" : "okay"),
                  onTap: () => onShowOrdersPagePressed
                      .call(paymentStatus.isPaid ? 1 : 0),
                )
              ],
            ),
          );
        });
  }
}
