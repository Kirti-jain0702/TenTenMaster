import 'package:delivoo/AppConfig/app_config.dart';
import 'package:delivoo/Auth/BLOC/auth_bloc.dart';
import 'package:delivoo/Auth/BLOC/auth_state.dart';
import 'package:delivoo/Cart/Bloc/offer_bloc.dart';
import 'package:delivoo/Cart/Bloc/offer_event.dart';
import 'package:delivoo/Cart/Bloc/offer_state.dart';
import 'package:delivoo/Cart/coupon.dart';
import 'package:delivoo/Cart/offers_page.dart';
import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Components/custom_dialog.dart';
import 'package:delivoo/Components/entry_field.dart';
import 'package:delivoo/Components/show_toast.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/AddressBloc/address_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/AddressBloc/address_event.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/AddressBloc/address_state.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CartQuantityBloc/cart_quantity_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CartQuantityBloc/cart_quantity_event.dart';
import 'package:delivoo/HomeOrderAccount/Home/UI/address_bottom_sheet.dart';
import 'package:delivoo/Items/items_tab.dart';
import 'package:delivoo/JsonFiles/Address/getaddress_json.dart';
import 'package:delivoo/JsonFiles/Products/product_data.dart';
import 'package:delivoo/JsonFiles/pre_order_data.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Payment/place_order_page.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/UtilityFunctions/app_settings.dart';
import 'package:delivoo/UtilityFunctions/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_moment/simple_moment.dart';

class ViewCart extends StatelessWidget {
  final Function onCartEmpty;

  ViewCart(this.onCartEmpty);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddressBloc>(
            create: (BuildContext context) =>
                AddressBloc()..add(GetSelectedAddressEvent())),
        BlocProvider<OfferBloc>(
          create: (BuildContext context) => OfferBloc(),
        )
      ],
      child: ViewCartBody(onCartEmpty),
    );
  }
}

class ViewCartBody extends StatefulWidget {
  final Function onCartEmpty;

  ViewCartBody(this.onCartEmpty);

  @override
  _ViewCartState createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCartBody>
    with SingleTickerProviderStateMixin {
  double taxInPercent = double.parse(AppSettings.taxInPercent);
  TextEditingController _instructionsController = TextEditingController();
  TextEditingController _promoController = TextEditingController();
  GetAddress _address;
  Coupon _coupon;
  String vendorName = '';
  double cartTotal = 0;
  bool isPaymentInfoOpen = false;
  double animatedHeight = 0;
  bool couponCodeFieldEmpty = true;
  bool isLoaderShowing = false;
  AnimationController _controller;

  getVendorAndTotal() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      cartTotal = getTotal();
      vendorName = prefs.getString('vendorName');
    });
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _promoController.addListener(() {
      bool isEmpty = _promoController.text.isEmpty;
      if (couponCodeFieldEmpty != isEmpty) {
        setState(() {
          couponCodeFieldEmpty = isEmpty;
        });
      }
    });
    super.initState();
    getVendorAndTotal();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CartQuantityBloc>(context).add(GetCartQuantityEvent());
    return BlocListener<OfferBloc, OfferState>(
        listener: (context, state) {
          if (state is OfferLoadingState)
            showLoader();
          else
            dismissLoader();

          if (state is OfferInValidState) {
            _applyCoupon(null);
            showToast(AppLocalizations.of(context)
                .getTranslationOf("invalid_coupon"));
            _promoController.clear();
          }
          if (state is OfferValidState) {
            _applyCoupon(state.coupon);
            _promoController.clear();
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context).confirm,
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            body: Stack(children: <Widget>[
              ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0, bottom: 16.0),
                    color: Theme.of(context).cardColor,
                    child: Text((vendorName ?? '').toUpperCase(),
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Color(0xff616161), letterSpacing: 0.67)),
                  ),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      color: Theme.of(context).cardColor,
                      thickness: 0.0,
                      height: 0,
                    ),
                    itemCount: cartProducts.length,
                    itemBuilder: (context, index) {
                      return cartOrderItemListTile(cartProducts[index]);
                    },
                  ),
                  Divider(
                    color: Theme.of(context).cardColor,
                    thickness: 6.7,
                    height: 6.7,
                  ),
                  Container(
                    // height: 53.3,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    margin: EdgeInsets.only(top: 8.0),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: EntryField(
                      imageColor: kDisabledColor,
                      isDense: true,
                      image: 'images/custom/ic_instruction.png',
                      hint: AppLocalizations.of(context).instruction,
                      controller: _instructionsController,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).cardColor,
                    thickness: 6.7,
                    height: 6.7,
                  ),
                  Container(color: Theme.of(context).cardColor, height: 550),
                ],
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Divider(
                              color: Theme.of(context).cardColor,
                              thickness: 6.7,
                              height: 6.7,
                            ),
                            (BlocProvider.of<AuthBloc>(context).state
                                    is Authenticated)
                                ? Container(
                                    // height: 53.3,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 4),
                                    margin: EdgeInsets.only(top: 8.0),
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    child: _coupon == null
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: TextFormField(
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .characters,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .secondaryHeaderColor),
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      hintStyle: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .caption
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor),
                                                      icon: ImageIcon(
                                                        AssetImage(
                                                            'images/custom/ic_promo.png'),
                                                        size: 20,
                                                        color: kDisabledColor,
                                                      ),
                                                      hintText:
                                                          'Apply Promo Code',
                                                      border:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                    ),
                                                    controller:
                                                        _promoController,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (couponCodeFieldEmpty) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              OffersPage(true)),
                                                    ).then((value) {
                                                      if (value != null &&
                                                          value is Coupon) {
                                                        BlocProvider.of<
                                                                    OfferBloc>(
                                                                context)
                                                            .add(
                                                                OfferVerifyEvent(
                                                                    value
                                                                        .code));
                                                      }
                                                    });
                                                  } else {
                                                    if (_promoController.text
                                                        .trim()
                                                        .isNotEmpty) {
                                                      BlocProvider.of<
                                                                  OfferBloc>(
                                                              context)
                                                          .add(OfferVerifyEvent(
                                                              _promoController
                                                                  .text
                                                                  .trim()));
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  width: 80,
                                                  height: 30,
                                                  child: Center(
                                                      child: Text(
                                                    AppLocalizations.of(context)
                                                        .getTranslationOf(
                                                            couponCodeFieldEmpty
                                                                ? "view"
                                                                : "apply"),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .scaffoldBackgroundColor),
                                                  )),
                                                ),
                                              ),
                                            ],
                                          )
                                        : ListTile(
                                            dense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10),
                                            leading: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Image.asset(
                                                'images/account/ic_menu_wallet.png',
                                                scale: 2.4,
                                              ),
                                            ),
                                            title: Text(
                                              _coupon.code,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(fontSize: 13),
                                            ),
                                            subtitle: Text(
                                              AppLocalizations.of(context)
                                                  .getTranslationOf(
                                                      "coupon_applied"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(fontSize: 11),
                                            ),
                                            trailing: GestureDetector(
                                                onTap: () => _applyCoupon(null),
                                                child:
                                                    Icon(Icons.highlight_off)),
                                          ),
                                  )
                                : SizedBox.shrink(),
                            Divider(
                              color: Theme.of(context).cardColor,
                              thickness: 6.7,
                              height: 12,
                            ),
                            SizedBox(height: 6),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPaymentInfoOpen = !isPaymentInfoOpen;
                                  if (isPaymentInfoOpen) {
                                    _controller.forward();
                                  } else {
                                    _controller.reverse();
                                  }
                                  /* isPaymentInfoOpen = !isPaymentInfoOpen;
                                  animatedHeight = isPaymentInfoOpen ? 140 : 0;*/
                                });
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 20.0),
                                    child: Text(
                                        AppLocalizations.of(context)
                                            .paymentInfo
                                            .toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(color: kDisabledColor)),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isPaymentInfoOpen =
                                              !isPaymentInfoOpen;
                                          if (isPaymentInfoOpen) {
                                            _controller.forward();
                                          } else {
                                            _controller.reverse();
                                          }
                                          /*  animatedHeight =
                                              isPaymentInfoOpen ? 140 : 0;*/
                                        });
                                      },
                                      icon: Icon(isPaymentInfoOpen
                                          ? Icons.keyboard_arrow_down
                                          : Icons.keyboard_arrow_up))
                                ],
                              ),
                            ),
                            SizeTransition(
                              sizeFactor: _controller,
                              child: Container(
                                height: 140,
                                //duration: Duration(milliseconds: 400),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 20.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              AppLocalizations.of(context)
                                                  .deliveryCharge,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                            Text(
                                              '${AppSettings.currencyIcon} ${AppSettings.setupNumber(AppSettings.deliveryFee)}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                          ]),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 20.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              AppLocalizations.of(context).sub,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                            Text(
                                              '${AppSettings.currencyIcon} ${cartTotal.toStringAsFixed(2)}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                          ]),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 20.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              AppLocalizations.of(context)
                                                  .service,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                            Text(
                                              AppSettings.currencyIcon +
                                                  ' ' +
                                                  ' ${((taxInPercent / 100) * cartTotal).toStringAsFixed(2)}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                          ]),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 20.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              AppLocalizations.of(context)
                                                  .discount,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                            Text(
                                              AppSettings.currencyIcon +
                                                  ' ' +
                                                  ' ${(_coupon == null ? 0 : _coupon.type == "percent" ? ((cartTotal * _coupon.reward) / 100) : (_coupon.reward)).toStringAsFixed(2)}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                          ]),
                                    ),
                                    Container(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 20.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              AppLocalizations.of(context)
                                                  .amount,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            Text(
                                              '${AppSettings.currencyIcon} ${total.toStringAsFixed(2)}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            BlocBuilder<AddressBloc, AddressState>(
                              builder: (context, state) {
                                _address =
                                    (state is GetSelectedAddressSuccessState &&
                                            state.address != null)
                                        ? state.address
                                        : null;
                                if (_address != null) {
                                  return Container(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                          top: 13.0,
                                          bottom: 13.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      color: Color(0xffc4c8c1),
                                                      size: 13.3,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                        AppLocalizations.of(context)
                                                            .deliver,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .copyWith(
                                                                color:
                                                                    kDisabledColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                    Text(_address.title,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .copyWith(
                                                                color: kMainColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  ],
                                                ),
                                                SizedBox(height: 12.0),
                                                Text(_address.formattedAddress,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        .copyWith(
                                                            fontSize: 11.7,
                                                            color:
                                                                Color(0xffb7b7b7)))
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 8.0),
                                          ElevatedButton(onPressed: ()=>showAddressSheet(), child: Text("Change location",style:TextStyle(fontSize: 12),))
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              },
                            ),
                            BottomBar(
                                text: AppLocalizations.of(context).pay +
                                    '${AppSettings.currencyIcon} ${total.toStringAsFixed(2)}',
                                onTap: () async {
                                  if (BlocProvider.of<AuthBloc>(context).state
                                      is Authenticated) {
                                    if (_address != null) {
                                      bool allowed = true;
                                      if (AppConfig.enableDistanceCheck) {
                                        allowed =
                                            await _checkDisplacement(_address);
                                      }
                                      if (allowed) {
                                        scheduleOrderSheet();
                                      } else {
                                        alertDistance();
                                      }
                                    } else {
                                      showAddressSheet();
                                    }
                                  } else {
                                    showCustomDialog(context);
                                  }
                                })
                          ])))
            ])));
  }

  void _applyCoupon(Coupon coupon) {
    setState(() {
      _coupon = coupon;
    });
  }

  Future<bool> _checkDisplacement(GetAddress address) async {
    bool toReturn = true;
    try {
      double distanceDeliverySetting =
          double.parse(AppSettings.deliveryDistance);
      if (distanceDeliverySetting != null) {
        double distanceVendorHome = Helper.calculateDistanceInMeters(
            cartProducts.first.vendorProducts.first.vendor.latitude,
            cartProducts.first.vendorProducts.first.vendor.longitude,
            address.latitude,
            address.longitude);
        if (distanceVendorHome > distanceDeliverySetting) toReturn = false;
      }
    } catch (e) {
      print("checkDisplacement: $e");
    }
    return toReturn;
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

  showAddressSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: false,
      builder: (context) => AddressBottomSheetPage(),
    ).then((valueAddress) =>
        BlocProvider.of<AddressBloc>(context).add(GetSelectedAddressEvent()));
  }

  double get total =>
      cartTotal +
      ((taxInPercent / 100) * cartTotal) +
      double.parse(AppSettings.deliveryFee) -
      (_coupon == null
          ? 0
          : _coupon.type == "percent"
              ? ((cartTotal * _coupon.reward) / 100)
              : (_coupon.reward));

  Widget cartOrderItemListTile(ProductData productData) {
    var theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: <Widget>[
          Divider(thickness: 2, height: 2, color: theme.cardColor),
          SizedBox(height: 8),
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    productData.title,
                    style: theme.textTheme.subtitle2
                        .copyWith(color: theme.secondaryHeaderColor),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                /*   return PopupMenuItem(
    child: Text(productData.addOnGroups[0].addOnChoices[0].title),
    value: 1,
    )*/
               if(productData.addOnGroups.length>0) PopupMenuButton(
                  onSelected: (val){
                    productData.price = productData
                        .addOnGroups[0]
                        .addOnChoices
                        .firstWhere(
                            (element) =>
                        element
                            .title ==
                            val)
                        .price;
                    setState(() {
                      productData.selectedKey= val;
                      productData.addOnGroups.first.addOnChoices.forEach((e) {
                        if(val==e.title){
                          e.selected=true;
                        }else{
                          e.selected=false;
                        }

                      });
                      cartTotal = getTotal();
                    });
                  },
                    itemBuilder: (context) =>
                        productData.addOnGroups[0].addOnChoices
                            .map((e) => PopupMenuItem(
                                  child: Text(e.title),
                                  value: e.title,
                                ))
                            .toList(),
                    child: Container(
                            margin: EdgeInsets.only(left: 6),
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 6),
                            decoration: BoxDecoration(
                                color: Color(0xfff8f9fd),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                    productData.selectedKey == null ||
                                            productData.selectedKey == ''
                                        ? productData.addOnGroups[0]
                                            .addOnChoices[0].title
                                        : productData.selectedKey,
                                    style: theme.textTheme.caption
                                        .copyWith(fontSize: 12)),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: kMainColor,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                              ],
                            ),
                          )
                        )else SizedBox()
              ],
            ),
            trailing: Container(
              width: 156,
              child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(
                  height: 32,
                  width: 72,
                  // alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.primaryColor),
                    // shape: BoxShape.circle,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          productData.quantity--;
                          if (productData.quantity < 1) {
                            cartProducts.removeWhere(
                                (element) => element.id == productData.id);
                          }
                          if (cartProducts.length == 0) {
                            BlocProvider.of<CartQuantityBloc>(context)
                                .add(GetCartQuantityEvent());
                            widget.onCartEmpty();
                          } else {
                            cartTotal = getTotal();
                            setState(() {});
                          }
                        },
                        child: Icon(
                          Icons.remove,
                          color: theme.primaryColor,
                          size: 20.0,
                        ),
                      ),
                      Text(productData.quantity.toString(),
                          style: theme.textTheme.caption
                              .copyWith(fontWeight: FontWeight.bold)),
                      InkWell(
                        onTap: () {
                          productData.quantity++;
                          cartTotal = getTotal();
                          setState(() {});
                        },
                        child: Icon(
                          Icons.add,
                          color: theme.primaryColor,
                          size: 20.0,
                        ),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Text('x',
                    style: theme.textTheme.caption
                        .copyWith(fontWeight: FontWeight.w500)),
                Spacer(),
                Text(
                  AppSettings.currencyIcon +
                      productData.price.toStringAsFixed(2),
                  style: theme.textTheme.caption,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void alertDistance() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
                title: Text(AppLocalizations.of(context)
                    .getTranslationOf("distance_conflict_title")),
                content: Text(AppLocalizations.of(context)
                    .getTranslationOf("distance_conflict_message")),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context).okay))
                ])).then((value) =>
        BlocProvider.of<AddressBloc>(context).add(ClearAddressEvent()));
  }

  scheduleOrderSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => OrderTypeWidget()).then((value) {
      if (value != null && value is PreOrderData) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceOrderPage(
              PreOrderData(
                total,
                _address.id,
                _instructionsController.text,
                _coupon != null ? _coupon.code : null,
                value.type,
                value.scheduled_on,
                value.order_type,
              ),
            ),
          ),
        );
      }
    });
  }
}

class OrderTypeWidget extends StatefulWidget {
  @override
  _OrderTypeWidgetState createState() => _OrderTypeWidgetState();
}

class _OrderTypeWidgetState extends State<OrderTypeWidget> {
  String orderType = "ASAP"; //ASAP or LATER
  String scheduledOnDate, scheduledOnTime;
  bool pickedDate = false, pickedTime = false;

  @override
  void initState() {
    Moment now = Moment.now();

    scheduledOnDate = now.format("yyyy-MM-dd");
    scheduledOnTime = now.format("HH:mm:ss");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 180,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: buildPickupTab(),
          ),
          BottomBar(
              onTap: () => Navigator.pop(
                    context,
                    PreOrderData(
                      null,
                      null,
                      null,
                      null,
                      this.orderType,
                      this.orderType == "ASAP"
                          ? null
                          : Moment.parse(
                                  scheduledOnDate + " " + scheduledOnTime)
                              .format("yyyy-MM-dd HH:mm:ss"),
                      "NORMAL",
                    ),
                  ),
              text: AppLocalizations.of(context).continueText)
        ],
      ),
    );
  }

  Column buildPickupTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RadioListTile(
          groupValue: orderType,
          value: "ASAP",
          title: Text(
            AppLocalizations.of(context).getTranslationOf("asSoonAsPossible"),
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            AppLocalizations.of(context)
                .getTranslationOf("pickupAndDeliverASAP"),
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: Theme.of(context).hintColor),
          ),
          onChanged: (value) {
            orderType = value;
            setState(() {});
          },
        ),
        RadioListTile(
          groupValue: orderType,
          value: "LATER",
          title: Text(
            AppLocalizations.of(context).getTranslationOf("scheduleDelivery"),
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            AppLocalizations.of(context)
                .getTranslationOf("scheduleDeliveryMsg"),
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: Theme.of(context).hintColor),
          ),
          onChanged: (value) {
            orderType = value;
            setState(() {});
          },
        ),
        if (orderType == "LATER")
          Padding(
            padding: EdgeInsetsDirectional.only(start: 18, end: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (orderType == "ASAP") return;
                    showDatePicker(
                            context: context,
                            initialDate: Moment.parse(scheduledOnDate).date,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 37)))
                        .then((value) {
                      if (value != null) {
                        scheduledOnDate =
                            Moment.fromDate(value).format("yyyy-MM-dd");
                        pickedDate = true;
                        setState(() {});
                      }
                    });
                  },
                  child: Row(children: [
                    Text(
                      pickedDate
                          ? Moment.parse(scheduledOnDate).format("dd MMM yyyy")
                          : AppLocalizations.of(context)
                              .getTranslationOf("schedule_date"),
                      style: Theme.of(context).textTheme.caption,
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Theme.of(context).primaryColor,
                      size: 16,
                    )
                  ]),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    if (orderType == "ASAP") return;
                    List<String> scheduledOnTimeSplit =
                        scheduledOnTime.split(":");
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                          hour: int.parse(scheduledOnTimeSplit[0]),
                          minute: int.parse(scheduledOnTimeSplit[1])),
                    ).then((picked) {
                      if (picked != null) {
                        scheduledOnTime = ((picked.hour.toString().length == 1
                                ? ("0" + picked.hour.toString())
                                : picked.hour.toString()) +
                            ":" +
                            (picked.minute.toString().length == 1
                                ? ("0" + picked.minute.toString())
                                : picked.minute.toString()) +
                            ":00");
                        pickedTime = true;
                        setState(() {});
                      }
                    });
                  },
                  child: Row(children: [
                    Text(
                      pickedTime
                          ? Moment.parse(
                                  scheduledOnDate + " " + scheduledOnTime)
                              .format("HH:mm")
                          : AppLocalizations.of(context)
                              .getTranslationOf("schedule_time"),
                      style: Theme.of(context).textTheme.caption,
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Theme.of(context).primaryColor,
                      size: 16,
                    )
                  ]),
                )
              ],
            ),
          ),
      ],
    );
  }
}
