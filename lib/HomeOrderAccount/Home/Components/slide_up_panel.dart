import 'package:delivoo/Chat/UI/chatting_page.dart';
import 'package:delivoo/Components/cached_image.dart';
import 'package:delivoo/Components/entry_field.dart';
import 'package:delivoo/Constants/constants.dart';
import 'package:delivoo/JsonFiles/Chat/chat.dart';
import 'package:delivoo/JsonFiles/Order/Get/order_data.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/UtilityFunctions/app_settings.dart';
import 'package:delivoo/UtilityFunctions/make_phone_call.dart';
import 'package:flutter/material.dart';

class SlideUpPanel extends StatefulWidget {
  final OrderData orderData;

  SlideUpPanel(this.orderData);

  @override
  _SlideUpPanelState createState() => _SlideUpPanelState();
}

class _SlideUpPanelState extends State<SlideUpPanel> {
  @override
  Widget build(BuildContext context) {
    var order = widget.orderData;
    return DraggableScrollableSheet(
      minChildSize:
          order.delivery != null && order.orderType.toLowerCase() != 'custom'
              ? 0.17
              : 0.05,
      initialChildSize:
          order.delivery != null && order.orderType.toLowerCase() != 'custom'
              ? 0.17
              : 0.05,
      maxChildSize: 0.975,
      builder: (context, controller) {
        return Container(
          padding: EdgeInsets.only(left: 4.0),
          color: Theme.of(context).cardColor,
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Hero(
                          tag: 'arrow',
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            color: kMainColor,
                          ),
                        ),
                      ),
                      if (order.delivery != null &&
                          order.orderType.toLowerCase() != 'custom')
                        Hero(
                          tag: 'Delivery Boy',
                          child: ListTile(
                            leading: CachedImage(
                              order.delivery.delivery?.user?.mediaUrls?.images
                                  ?.first?.defaultImage,
                              radius: 30,
                              width: 56,
                            ),
                            title: Text(
                              order.delivery.delivery.user.name,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            subtitle: Text(
                              AppLocalizations.of(context)
                                  .getTranslationOf('no_transactions'),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontSize: 11.7,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xffc2c2c2),
                                  ),
                            ),
                            trailing: FittedBox(
                              fit: BoxFit.fill,
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    icon:
                                        Icon(Icons.message, color: kMainColor),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChattingPage(
                                            Chat.fromOrder(
                                                order, Constants.ROLE_DELIVERY),
                                            order.id,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.phone, color: kMainColor),
                                    onPressed: () => makePhoneCall(order
                                        .delivery.delivery.user.mobileNumber),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      // else
                      //   ListTile(
                      //     leading: CircleAvatar(
                      //       backgroundColor: Theme.of(context).primaryColor,
                      //       foregroundColor:
                      //           Theme.of(context).scaffoldBackgroundColor,
                      //       child: Icon(Icons.person),
                      //     ),
                      //     title: Text(
                      //       AppLocalizations.of(context)
                      //           .getTranslationOf('not_assigned_yet'),
                      //       style: Theme.of(context).textTheme.headline4,
                      //     ),
                      //     subtitle: Text(
                      //       AppLocalizations.of(context)
                      //           .getTranslationOf('delivery_partner'),
                      //       style: Theme.of(context)
                      //           .textTheme
                      //           .headline6
                      //           .copyWith(
                      //               fontSize: 11.7,
                      //               fontWeight: FontWeight.w500,
                      //               color: Color(0xffc2c2c2)),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
                SizedBox(height: 6.0),
                if (order.orderType.toLowerCase() != 'custom')
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: order.products.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      var product = order.products[index];
                      return ListTile(
                        tileColor: Theme.of(context).scaffoldBackgroundColor,
                        title: Text(
                          product.vendorProduct.product.title ??
                              AppLocalizations.of(context)
                                  .getTranslationOf('product'),
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 15.0),
                        ),
                        subtitle: Text(
                          product.quantity.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(fontSize: 13.3),
                        ),
                        trailing: Text(
                          AppSettings.currencyIcon +
                              ' ${product.vendorProduct.price}',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(fontSize: 13.3),
                        ),
                      );
                    },
                  ),
                if (order.orderType.toLowerCase() == 'custom' &&
                    order.meta != null)
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: order.meta.packageTypes.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      var packageType = order.meta.packageTypes[index];
                      return ListTile(
                        tileColor: Theme.of(context).scaffoldBackgroundColor,
                        title: Text(
                          packageType,
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 15.0),
                        ),
                      );
                    },
                  ),

                SizedBox(height: 6.0),
                // Container(
                //   height: 50.0,
                //   padding: EdgeInsets.symmetric(horizontal: 8.0),
                //   color: Theme.of(context).scaffoldBackgroundColor,
                //   child: Row(
                //     children: [
                //       ImageIcon(
                //         AssetImage('images/custom/ic_instruction.png'),
                //         color: kLightTextColor,
                //         size: 20.0,
                //       ),
                //       SizedBox(
                //         width: 10.0,
                //       ),
                //       Text(
                //         order.notes ?? '',
                //         style: Theme.of(context)
                //             .textTheme
                //             .caption
                //             .copyWith(color: kLightTextColor),
                //       ),
                //     ],
                //   ),
                // ),
                if (order.notes != null && order.notes.isNotEmpty)
                  EntryField(
                    image: 'images/custom/ic_instruction.png',
                    imageColor: kLightTextColor,
                    initialValue: order.notes,
                    readOnly: true,
                    border: InputBorder.none,
                  ),
                SizedBox(height: 6.0),
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                  child: Text(AppLocalizations.of(context).paymentInfo,
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: kDisabledColor,
                          fontSize: 13.3,
                          letterSpacing: 0.67)),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                // Container(
                //   color: Theme.of(context).scaffoldBackgroundColor,
                //   padding:
                //       EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                //   child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: <Widget>[
                //         Text(
                //           AppLocalizations.of(context).sub,
                //           style: Theme.of(context).textTheme.caption,
                //         ),
                //         Text(
                //           '${AppSettings.currencyIcon} ${order.subtotal}',
                //           style: Theme.of(context).textTheme.caption,
                //         ),
                //       ]),
                // ),
                if (order.orderType.toLowerCase() != 'custom')
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context).service,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          Text(
                            '${AppSettings.currencyIcon} ${order.taxes.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ]),
                  ),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).deliveryCharge,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          '${AppSettings.currencyIcon} ${order.deliveryFee.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ]),
                ),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).cod,
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                        ),
                        Text(
                          '${AppSettings.currencyIcon} ${order.total.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
