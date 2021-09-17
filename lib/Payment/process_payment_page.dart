import 'dart:collection';

import 'package:delivoo/JsonFiles/Order/Get/payment.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'PaymentBloc/payment_bloc.dart';
import 'PaymentBloc/payment_event.dart';
import 'PaymentBloc/payment_state.dart';

class ProcessPaymentPage extends StatelessWidget {
  final PaymentData paymentData;
  ProcessPaymentPage(this.paymentData);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PaymentBloc(),
      child: ProcessPaymentWidget(paymentData),
    );
  }
}

class ProcessPaymentWidget extends StatefulWidget {
  final PaymentData paymentData;
  ProcessPaymentWidget(this.paymentData);

  @override
  ProcessPaymentWidgetState createState() => ProcessPaymentWidgetState();
}

class ProcessPaymentWidgetState extends State<ProcessPaymentWidget> {
  final GlobalKey webViewKey = GlobalKey();
  PaymentBloc _paymentBloc;
  String _initialUrlRequest, _sUrl, _fUrl;
  PaymentStatus _paymentStatus;

  Future<bool> _warnPop() async {
    var value = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
            AppLocalizations.of(context).getTranslationOf("warn_back_title")),
        content: Text(
            AppLocalizations.of(context).getTranslationOf("warn_back_message")),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context).no)),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppLocalizations.of(context).yes))
        ],
      ),
    );
    return value != null && value == true;
  }

  @override
  void initState() {
    super.initState();
    _paymentBloc = BlocProvider.of<PaymentBloc>(context);
    _paymentBloc.add(InitPaymentProcessEvent(widget.paymentData));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool popSure = await _warnPop();
        if (popSure) {
          _paymentBloc.add(SetPaymentProcessedEvent(false));
        }
        return false;
      },
      child: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is ProcessingPaymentState) {
            setState(() {
              _initialUrlRequest = null;
              _sUrl = null;
              _fUrl = null;
            });
          } else if (state is LoadPaymentUrlState) {
            setState(() {
              _initialUrlRequest = state.paymentLink;
              _sUrl = state.sUrl;
              _fUrl = state.fUrl;
            });
          } else if (state is ProcessedPaymentState) {
            _paymentStatus = state.paymentStatus;
            Navigator.pop(context, _paymentStatus);
          }
        },
        child: Scaffold(
          backgroundColor: kWhiteColor,
          body: _initialUrlRequest != null
              ? SafeArea(
                  child: InAppWebView(
                    key: webViewKey,
                    // contextMenu: contextMenu,
                    initialUrlRequest: URLRequest(
                      url: Uri.parse(_initialUrlRequest),
                    ),
                    // initialFile: "assets/index.html",
                    initialUserScripts: UnmodifiableListView<UserScript>([]),
                    initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          useShouldOverrideUrlLoading: true,
                          mediaPlaybackRequiresUserGesture: false,
                        ),
                        android: AndroidInAppWebViewOptions(
                          useHybridComposition: true,
                        ),
                        ios: IOSInAppWebViewOptions(
                          allowsInlineMediaPlayback: true,
                        )),
                    pullToRefreshController: null,
                    onWebViewCreated: (controller) {
                      //webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      // setState(() {
                      //   this.url = url.toString();
                      //   urlController.text = this.url;
                      // });
                    },
                    androidOnPermissionRequest:
                        (controller, origin, resources) async {
                      return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT);
                    },
                    shouldOverrideUrlLoading: null,
                    onLoadStop: (controller, url) async {
                      print("loadstop: $url");
                      if (url.toString() == _sUrl) {
                        _paymentBloc.add(SetPaymentProcessedEvent(true));
                      }
                      if (url.toString() == _fUrl) {
                        _paymentBloc.add(SetPaymentProcessedEvent(false));
                      }
                      // pullToRefreshController.endRefreshing();
                      // setState(() {
                      //   this.url = url.toString();
                      //   urlController.text = this.url;
                      // });
                    },
                    onLoadError: (controller, url, code, message) {
                      // pullToRefreshController.endRefreshing();
                      _paymentBloc.add(SetPaymentProcessedEvent(false));
                    },
                    onProgressChanged: (controller, progress) {
                      // if (progress == 100) {
                      //   pullToRefreshController.endRefreshing();
                      // }
                      // setState(() {
                      //   this.progress = progress / 100;
                      //   urlController.text = this.url;
                      // });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      // setState(() {
                      //   this.url = url.toString();
                      //   urlController.text = this.url;
                      // });
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print(consoleMessage);
                    },
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kMainColor),
                  ),
                ),
        ),
      ),
    );
  }
}

class PaymentData {
  final Payment payment;
  final PayUMeta payuMeta;
  final String stripeTokenId;

  PaymentData({this.payment, this.payuMeta, this.stripeTokenId});
}

class PayUMeta {
  final String name, mobile, email, bookingId, productinfo;

  PayUMeta(
      {this.name, this.mobile, this.email, this.bookingId, this.productinfo});
}
