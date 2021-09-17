import 'package:delivoo/Components/show_toast.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CartQuantityBloc/cart_quantity_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CartQuantityBloc/cart_quantity_event.dart';
import 'package:delivoo/HomeOrderAccount/Home/checkout_navigator.dart';
import 'package:delivoo/Items/items_tab.dart';
import 'package:delivoo/JsonFiles/Order/Post/create_order.dart';
import 'package:delivoo/JsonFiles/Order/Post/order_product.dart';
import 'package:delivoo/JsonFiles/PaymentMethod/payment_method.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Pages/Payment/PaymentBloc/payment_bloc.dart';
import 'package:delivoo/Pages/Payment/PaymentBloc/payment_event.dart';
import 'package:delivoo/Pages/Payment/PaymentBloc/payment_state.dart';
import 'package:delivoo/Pages/Payment/PlaceOrderBloc/place_order_bloc.dart';
import 'package:delivoo/Pages/Payment/PlaceOrderBloc/place_order_event.dart';
import 'package:delivoo/Pages/Payment/PlaceOrderBloc/place_order_state.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/UtilityFunctions/app_settings.dart';
import 'package:delivoo/UtilityFunctions/card_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentPage extends StatelessWidget {
  final PaymentData paymentData;

  PaymentPage(this.paymentData);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<PaymentBloc>(
        create: (BuildContext context) =>
            PaymentBloc()..add(FetchPaymentEvent()),
      ),
      BlocProvider<PlaceOrderBloc>(
        create: (BuildContext context) => PlaceOrderBloc(),
      ),
    ], child: PaymentBody(paymentData));
  }
}

class PaymentBody extends StatefulWidget {
  final PaymentData paymentData;

  PaymentBody(this.paymentData);

  @override
  _PaymentBodyState createState() => _PaymentBodyState();
}

class _PaymentBodyState extends State<PaymentBody> {
  PlaceOrderBloc _placeOrderBloc;
  List<OrderProduct> postOrders = [];
  bool isLoaderShowing = false;

  @override
  void initState() {
    super.initState();
    _placeOrderBloc = BlocProvider.of<PlaceOrderBloc>(context);
    addItems();
  }

  void addItems() {
    for (var product in cartProducts) {
      postOrders.add(
        OrderProduct(
            product.vendorProducts
                .singleWhere((element) => element.productId == product.id)
                .id,
            product.quantity,
            product.getChoiceIds()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlaceOrderBloc, PlaceOrderState>(
      listener: (context, state) {
        if (state is LoadingPlaceOrderState) {
          showLoader();
        } else {
          dismissLoader();
        }
        if (state is FailurePlaceOrderState) {
          showToast(AppLocalizations.of(context)
              .getTranslationOf(state.errorMessage));
        }
        if (state is SuccessPlaceOrderState) {
          if (!state.paid)
            showToast(AppLocalizations.of(context)
                .getTranslationOf("placed_pay_failed"));
          Navigator.pushReplacementNamed(context, CheckoutRoutes.orderPlaced);
          BlocProvider.of<CartQuantityBloc>(context)
              .add(UpdateCartQuantityEvent(0));
        }
      },
      child: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          if (state is SuccessPaymentState) {
            return Scaffold(
              backgroundColor: Theme.of(context).cardColor,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(68.0),
                child: AppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  automaticallyImplyLeading: true,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context).selectPayment,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        AppLocalizations.of(context).amount +
                            '${AppSettings.currencyIcon} ${widget.paymentData.totalPrice.toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: kDisabledColor),
                      ),
                    ],
                  ),
                ),
              ),
              body: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Divider(
                    color: Theme.of(context).cardColor,
                    height: 6.7,
                    thickness: 6.7,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.listOfPaymentMethods.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          tileColor: Theme.of(context).scaffoldBackgroundColor,
                          onTap: () {
                            if (state.listOfPaymentMethods[index].slug ==
                                "stripe") {
                              placeOrderPickCard(
                                  state.listOfPaymentMethods[index]);
                            } else {
                              placeOrder(state.listOfPaymentMethods[index]);
                            }
                          },
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 20.0),
                          leading: getPaymentIconWidget(
                              state.listOfPaymentMethods[index].slug),
                          title: Text(
                            state.listOfPaymentMethods[index].title,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.07),
                          ),
                          trailing: Text(
                            '${AppSettings.currencyIcon} ${widget.paymentData.totalPrice.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: kDisabledColor),
                          ),
                        );
                      }),
                  // Container(
                  //   color: Theme.of(context).cardColor,
                  //   padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  //   child: Text(
                  //     AppLocalizations.of(context).other.toUpperCase(),
                  //     style: Theme.of(context).textTheme.bodyText1.copyWith(
                  //         color: Theme.of(context).hintColor, fontSize: 14),
                  //   ),
                  // ),
                  // ListTile(
                  //   tileColor: Theme.of(context).scaffoldBackgroundColor,
                  //   onTap: () async {},
                  //   contentPadding:
                  //       EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                  //   leading: Image.asset(
                  //     'images/payment/payment_paypal.png',
                  //     height: 30,
                  //   ),
                  //   title: Text(
                  //     'PayPal',
                  //     style: Theme.of(context).textTheme.headline4.copyWith(
                  //         fontWeight: FontWeight.w500, letterSpacing: 0.07),
                  //   ),
                  // )
                ],
              ),
            );
          } else if (state is FetchPaymentEvent) {
            return Text(AppLocalizations.of(context)
                .getTranslationOf("couldNotLoadPage"));
          } else {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        },
      ),
    );
  }

  showLoader() {
    if (!isLoaderShowing) {
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(kMainColor),
          ));
        },
      );
      isLoaderShowing = true;
    }
  }

  dismissLoader() {
    if (isLoaderShowing) {
      Navigator.of(context).pop();
      isLoaderShowing = false;
    }
  }

  void placeOrderPickCard(PaymentMethod paymentMethod) async {
    CardInfo cardInfo = await CardPicker.getSavedCard();
    CardPicker.pickCard(context, cardInfo, true).then((value) {
      if (value != null && value is CardInfo)
        _placeOrderBloc.add(PlaceOrderEvent(
            widget.paymentData.totalPrice,
            paymentMethod,
            value,
            CreateOrder(
                widget.paymentData.addressId,
                paymentMethod.slug,
                postOrders,
                widget.paymentData.type,
                widget.paymentData.scheduled_on,
                widget.paymentData.notes,
                widget.paymentData.coupon_code,
                widget.paymentData.order_type)));
    });
  }

  placeOrder(PaymentMethod paymentMethod) {
    _placeOrderBloc.add(PlaceOrderEvent(
        widget.paymentData.totalPrice,
        paymentMethod,
        null,
        CreateOrder(
            widget.paymentData.addressId,
            paymentMethod.slug,
            postOrders,
            widget.paymentData.type,
            widget.paymentData.scheduled_on,
            widget.paymentData.notes,
            widget.paymentData.coupon_code,
            widget.paymentData.order_type)));
  }

  getPaymentIconWidget(String paymentSlug) {
    switch (paymentSlug) {
      case "cod":
        return Image.asset(
          'images/payment/payment_cod.png',
          height: 30,
        );
      case "wallet":
        return Icon(
          Icons.account_balance_wallet_rounded,
          color: Theme.of(context).primaryColor,
        );
      case "paypal":
        return Image.asset(
          'images/payment/payment_paypal.png',
          height: 30,
        );
      default:
        return Icon(
          Icons.credit_card_rounded,
          color: Theme.of(context).primaryColor,
        );
    }
  }
}
