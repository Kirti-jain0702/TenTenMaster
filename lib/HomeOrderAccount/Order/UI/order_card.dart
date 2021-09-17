import 'package:delivoo/Components/cached_image.dart';
import 'package:delivoo/JsonFiles/Order/Get/order_data.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Routes/routes.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/Themes/style.dart';
import 'package:delivoo/UtilityFunctions/app_settings.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final OrderData orderData;

  OrderCard(this.orderData);

  @override
  Widget build(BuildContext context) {
    return orderData.isLoadingOrder()
        ? Container(
            height: 64,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : GestureDetector(
            onTap: () => Navigator.pushNamed(context, PageRoutes.orderInfoPage,
                arguments: orderData),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: orderData.vendor != null
                          ? CachedImage(
                              orderData.vendor.mediaUrls?.images?.first
                                  ?.defaultImage,
                              height: 70,
                            )
                          : Image.asset(
                              'images/maincategory/custom_deliveryact.png',
                              height: 70,
                            ),
                    ),
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsetsDirectional.only(end: 12),
                        title: Text(
                          orderData.vendor?.name ??
                              AppLocalizations.of(context).custom,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          orderData.createdAtFormatted,
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 11.7, color: Color(0xffc1c1c1)),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).getTranslationOf(
                                  "order_status_" + orderData.status),
                              style: orderMapAppBarTextStyle.copyWith(
                                  color: kMainColor),
                            ),
                            SizedBox(height: 6.0),
                            Text(
                              AppSettings.currencyIcon +
                                  ' ${orderData.total.toStringAsFixed(2)} | ${orderData.payment.paymentMethod?.title ?? " "}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      fontSize: 11.7,
                                      letterSpacing: 0.06,
                                      color: Color(0xffc1c1c1)),
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
                  height: 8,
                ),
                Stack(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Icon(
                                Icons.location_on,
                                color: kMainColor,
                                size: 13.3,
                              ),
                            ),
                            Text(
                              (orderData.vendor?.name ??
                                  (orderData.sourceAddress.name ?? '')),
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(
                                      fontSize: 10.0,
                                      letterSpacing: 0.05,
                                      fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Text(
                                ' (${orderData.vendor?.address ?? orderData.sourceAddress.formattedAddress})',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        fontSize: 10.0, letterSpacing: 0.05),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Icon(
                                Icons.navigation,
                                color: kMainColor,
                                size: 13.3,
                              ),
                            ),
                            Text(
                              orderData.orderType.toLowerCase() == 'custom'
                                  ? orderData.address.name
                                  : (orderData.user?.name ?? ''),
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(
                                      fontSize: 10.0,
                                      letterSpacing: 0.05,
                                      fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Text(
                                ' (${orderData.address.formattedAddress})',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        fontSize: 10.0, letterSpacing: 0.05),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      left: 21.5,
                      top: 23,
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 1.2,
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            CircleAvatar(
                              radius: 1.2,
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            CircleAvatar(
                              radius: 1.2,
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Theme.of(context).cardColor,
                  thickness: 16.0,
                  height: 32,
                ),
              ],
            ),
          );
  }
}
