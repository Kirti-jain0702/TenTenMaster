import 'dart:async';

import 'package:delivoo/Chat/UI/chatting_page.dart';
import 'package:delivoo/Components/cached_image.dart';
import 'package:delivoo/Constants/constants.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/OrderMapBloc/order_map_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/OrderMapBloc/order_map_event.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/OrderMapBloc/order_map_state.dart';
import 'package:delivoo/HomeOrderAccount/Home/Components/slide_up_panel.dart';
import 'package:delivoo/HomeOrderAccount/Order/Blocs/OrderBloc/orders_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Order/Blocs/OrderBloc/orders_event.dart';
import 'package:delivoo/HomeOrderAccount/Order/Blocs/OrderBloc/orders_state.dart';
import 'package:delivoo/JsonFiles/Chat/chat.dart';
import 'package:delivoo/JsonFiles/Order/Get/order_data.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Maps/map_repository.dart';
import 'package:delivoo/Routes/routes.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/Themes/style.dart';
import 'package:delivoo/UtilityFunctions/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OrderData orderData = ModalRoute.of(context).settings.arguments;
    var pickupLatLng = orderData.sourceAddress != null
        ? LatLng(
            orderData.sourceAddress.latitude, orderData.sourceAddress.longitude)
        : LatLng(orderData.vendor.latitude, orderData.vendor.longitude);
    var dropLatLng =
        LatLng(orderData.address.latitude, orderData.address.longitude);
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrdersBloc>(
          create: (context) =>
              OrdersBloc.orderDetail(orderData)..add(FetchOrderUpdatesEvent()),
        ),
        BlocProvider<OrderMapBloc>(
          create: (context) => OrderMapBloc(pickupLatLng, dropLatLng,
              orderData.notes ?? '', orderData.delivery?.delivery?.id)
            ..add(LoadPageEvent()),
        ),
      ],
      child: OrderInfoBody(),
    );
  }
}

class OrderInfoBody extends StatefulWidget {
  @override
  _OrderInfoBodyState createState() => _OrderInfoBodyState();
}

class _OrderInfoBodyState extends State<OrderInfoBody> {
  OrderMapBloc _orderMapBloc;
  bool _showRateVendor = false;

  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    _orderMapBloc = BlocProvider.of<OrderMapBloc>(context);
  }

  GoogleMap buildGoogleMap(OrderMapState state) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: state.pickupLatLng,
        zoom: 13.0,
      ),
      mapType: MapType.normal,
      markers: state.markers.toSet(),
      polylines: state.polylines,
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) async {
        String mapStyle = await MapRepository().loadSilverMap();
        await controller.setMapStyle(mapStyle);
        _controller.complete(controller);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersBloc, OrdersState>(
      listener: (context, state) async {
        if (state is OrderSuccess) {
          if (state.order.delivery != null) {
            _orderMapBloc
                .add(AddDeliveryIdEvent(state.order.delivery.delivery.id));
          }
          if (state.order.vendor != null) {
            var prefs = await SharedPreferences.getInstance();
            bool isRated =
                prefs.getBool("reviewed_vendor_${state.order.vendorId}") ??
                    false;
            if (state.order.status == 'complete' && !isRated) {
              Navigator.pushNamed(context, PageRoutes.rateNow,
                  arguments: state.order.vendor);
            }
          }
        }
      },
      builder: (context, state) {
        return FocusDetector(
            onFocusGained: () async {
              if (state is OrderSuccess) {
                var prefs = await SharedPreferences.getInstance();
                bool isRated =
                    prefs.getBool("reviewed_vendor_${state.order.vendorId}") ??
                        false;
                setState(() {
                  _showRateVendor =
                      state.order.status == 'complete' && !isRated;
                });
              }
            },
            child: state is OrderSuccess
                ? Scaffold(
                    // appBar: ,
                    body: Column(
                      children: <Widget>[
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              BlocBuilder<OrderMapBloc, OrderMapState>(
                                builder: (context, state) {
                                  return buildGoogleMap(state);
                                },
                              ),
                              Positioned(
                                top: 80,
                                left: 0,
                                right: 0,
                                child: Container(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      if (state.order.orderType.toLowerCase() !=
                                          'custom')
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.3),
                                                child: CachedImage(
                                                  state.order.vendor.mediaUrls
                                                      .images[0].defaultImage,
                                                  height: 40,
                                                  width: 40,
                                                )),
                                            Expanded(
                                              child: ListTile(
                                                title: Text(
                                                  state.order.vendor.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      .copyWith(
                                                          letterSpacing: 0.07,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                subtitle: (state.order.type ==
                                                            "LATER" &&
                                                        state.order
                                                                .scheduledOn !=
                                                            null)
                                                    ? Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${AppLocalizations.of(context).getTranslationOf("created")}: ${state.order.createdAtFormatted}",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6
                                                                .copyWith(
                                                                    fontSize:
                                                                        11.7,
                                                                    letterSpacing:
                                                                        0.06,
                                                                    color: Color(
                                                                        0xffc1c1c1)),
                                                          ),
                                                          Text(
                                                            "${AppLocalizations.of(context).getTranslationOf("scheduled")}: ${state.order.scheduledOnFormatted}",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6
                                                                .copyWith(
                                                                    fontSize:
                                                                        11.7,
                                                                    letterSpacing:
                                                                        0.06,
                                                                    color: Color(
                                                                        0xffc1c1c1)),
                                                          )
                                                        ],
                                                      )
                                                    : Text(
                                                        "${AppLocalizations.of(context).getTranslationOf("created")}: ${state.order.createdAtFormatted}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6
                                                            .copyWith(
                                                                fontSize: 11,
                                                                letterSpacing:
                                                                    0.06,
                                                                color: Color(
                                                                    0xffc1c1c1)),
                                                      ),
                                                trailing: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: <Widget>[
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .getTranslationOf(
                                                              "order_status_" +
                                                                  state.order
                                                                      .status),
                                                      style:
                                                          orderMapAppBarTextStyle
                                                              .copyWith(
                                                                  color:
                                                                      kMainColor),
                                                    ),
                                                    SizedBox(height: 7.0),
                                                    Text(
                                                      AppSettings.currencyIcon +
                                                          '${state.order.total.toStringAsFixed(2)} | ${state.order.payment.paymentMethod?.title ?? " "}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .copyWith(
                                                              fontSize: 11.7,
                                                              letterSpacing:
                                                                  0.06,
                                                              color: Color(
                                                                  0xffc1c1c1)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      Divider(
                                        color: Theme.of(context).cardColor,
                                        thickness: 1.0,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 36.0,
                                                bottom: 6.0,
                                                top: 6.0,
                                                right: 12.0),
                                            child: Icon(
                                              Icons.location_on,
                                              color: kMainColor,
                                              size: 13.3,
                                            ),
                                          ),
                                          Text(
                                            (state.order.vendor?.name ??
                                                (state.order.sourceAddress
                                                        .name ??
                                                    '')),
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                    fontSize: 10.0,
                                                    letterSpacing: 0.05,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          Flexible(
                                            child: Text(
                                              ' (${state.order.vendor?.address ?? state.order.sourceAddress.formattedAddress})',
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .copyWith(
                                                      fontSize: 10.0,
                                                      letterSpacing: 0.05),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 36.0,
                                                bottom: 12.0,
                                                top: 12.0,
                                                right: 12.0),
                                            child: Icon(
                                              Icons.navigation,
                                              color: kMainColor,
                                              size: 13.3,
                                            ),
                                          ),
                                          Text(
                                            state.order.orderType
                                                        .toLowerCase() ==
                                                    'custom'
                                                ? state.order.address.name
                                                : (state.order.user?.name ??
                                                    ''),
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                    fontSize: 10.0,
                                                    letterSpacing: 0.05,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          Flexible(
                                            child: Text(
                                              ' (${state.order.address.formattedAddress})',
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .copyWith(
                                                      fontSize: 10.0,
                                                      letterSpacing: 0.05),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                height: 80,
                                child: AppBar(
                                  title: Text(
                                      "${AppLocalizations.of(context).getTranslationOf("order_number")}${state.order.id.toString()}${state.order.orderType.toLowerCase() == "takeaway" ? ", ${AppLocalizations.of(context).getTranslationOf("takeaway")}" : ""}"),
                                  titleSpacing: 0.0,
                                  actions: [
                                    if (_showRateVendor)
                                      IconButton(
                                        icon:
                                            Icon(Icons.star, color: kMainColor),
                                        onPressed: () => Navigator.pushNamed(
                                            context, PageRoutes.rateNow,
                                            arguments: state.order.vendor),
                                      ),
                                    if (state.order.orderType.toLowerCase() !=
                                        'custom')
                                      IconButton(
                                        icon: Icon(Icons.message,
                                            color: kMainColor),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChattingPage(
                                                Chat.fromOrder(state.order,
                                                    Constants.ROLE_VENDOR),
                                                state.order.id,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                  ],
                                ),
                              ),
                              SlideUpPanel(state.order),
                            ],
                          ),
                        ),
                        Container(
                          height: 60.0,
                          color: Theme.of(context).cardColor,
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                state.order.orderType.toLowerCase() == 'custom'
                                    ? AppLocalizations.of(context).custom
                                    : '${state.order.products.length} ' +
                                        AppLocalizations.of(context)
                                            .getTranslationOf('items'),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                              ),
                              // FlatButton.icon(
                              //     onPressed: () {},
                              //     icon: Icon(
                              //       Icons.keyboard_arrow_up,
                              //       color: Theme.of(context).primaryColor,
                              //     ),
                              //     label: Text(AppLocalizations.of(context).orderInfo))
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ));
      },
    );
  }
}
