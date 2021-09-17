import 'package:delivoo/Cart/order_placed.dart';
import 'package:delivoo/Cart/view_cart.dart';
import 'package:delivoo/HomeOrderAccount/Order/UI/list_of_order_page.dart';
import 'package:delivoo/HomeOrderAccount/home_order_account.dart';
import 'package:delivoo/Pages/Payment/payment_method.dart';
import 'package:flutter/material.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class CheckoutRoutes {
  static const String cartPage = 'checkout/cart_page';
  static const String paymentPage = 'checkout/payment_page';
  static const String orderPlaced = 'checkout/order_placed';
  static const String ordersPage = 'checkout/orders_page';
}

class CheckoutNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        var canPop = navigatorKey.currentState.canPop();
        if (canPop) {
          navigatorKey.currentState.pop();
        }
        return !canPop;
      },
      child: Navigator(
        key: navigatorKey,
        initialRoute: CheckoutRoutes.cartPage,
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case CheckoutRoutes.cartPage:
              builder =
                  (BuildContext _) => ViewCart(() => Navigator.pop(context));
              break;
            case CheckoutRoutes.paymentPage:
              builder = (BuildContext _) =>
                  PaymentPage(settings.arguments as PaymentData);
              break;
            case CheckoutRoutes.orderPlaced:
              builder = (BuildContext _) => OrderPlaced(() =>
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeOrderAccount(1)),
                      (route) => false));
              break;
            case CheckoutRoutes.ordersPage:
              builder = (BuildContext _) => OrderPage();
              break;
            // case PageRoutes.locationPage:
            //   builder = (BuildContext _) => LocationPage();
            //   break;
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
        onPopPage: (Route<dynamic> route, dynamic result) {
          return route.didPop(result);
        },
      ),
    );
  }
}

class PaymentData {
  final double totalPrice;
  final int addressId;
  final String notes, coupon_code, type, scheduled_on, order_type;

  PaymentData(this.totalPrice, this.addressId, this.notes, this.coupon_code,
      this.type, this.scheduled_on, this.order_type);
}
