import 'package:clipboard/clipboard.dart';
import 'package:delivoo/Cart/Bloc/offer_bloc.dart';
import 'package:delivoo/Cart/Bloc/offer_event.dart';
import 'package:delivoo/Cart/Bloc/offer_state.dart';
import 'package:delivoo/Cart/coupon.dart';
import 'package:delivoo/Components/error_final_widget.dart';
import 'package:delivoo/Components/show_toast.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OffersPage extends StatelessWidget {
  final bool pickOnly;

  OffersPage([this.pickOnly]);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OfferBloc>(
      create: (BuildContext context) => OfferBloc()..add(OffersFetchEvent()),
      child: _Offers(pickOnly != null ? pickOnly : false),
    );
  }
}

class _Offers extends StatefulWidget {
  final bool pickOnly;

  _Offers(this.pickOnly);

  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<_Offers> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfferBloc, OfferState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(AppLocalizations.of(context).getTranslationOf('offers'),
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(fontWeight: FontWeight.bold)),
          actions: [
            if (state is OfferLoadedState && state.coupons.isNotEmpty)
              Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  AppLocalizations.of(context).getTranslationOf(
                      widget.pickOnly ? "tap_select" : "tap_copy"),
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
          child: (state is OfferLoadedState && state.coupons.isNotEmpty)
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: state.coupons.length,
                  itemBuilder: (context, index) {
                    return buildOfferTile(state.coupons[index], context);
                  })
              : state is OfferLoadingState
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ErrorFinalWidget.errorWithRetry(
                          context,
                          AppLocalizations.of(context)
                              .getTranslationOf("empty_coupons"),
                          AppLocalizations.of(context)
                              .getTranslationOf("retry"),
                          () => BlocProvider.of<OfferBloc>(context)
                              .add(OffersFetchEvent())),
                    ),
        ),
      );
    });
  }

  Widget buildOfferTile(Coupon coupon, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 8),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: GestureDetector(
        onTap: () {
          if (widget.pickOnly) {
            Navigator.pop(context, coupon);
          } else {
            FlutterClipboard.copy(coupon.code).then((value) => showToast(
                AppLocalizations.of(context).getTranslationOf("code_copied")));
          }
        },
        child: ListTile(
          title: Text(
            coupon.detail,
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
              coupon.expiresAtFormatted == "expired"
                  ? AppLocalizations.of(context).getTranslationOf("expired")
                  : (AppLocalizations.of(context)
                          .getTranslationOf("expires_at") +
                      " " +
                      coupon.expiresAtFormatted),
              style: Theme.of(context).textTheme.caption.copyWith(
                  fontSize: 10.0,
                  color: Theme.of(context).hintColor,
                  height: 1.8)),
          trailing: FittedBox(
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(100),
              color: Theme.of(context).primaryColor,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Theme.of(context).primaryColor.withOpacity(0.05)),
                child: Text(coupon.code,
                    style: Theme.of(context).textTheme.caption.copyWith(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
