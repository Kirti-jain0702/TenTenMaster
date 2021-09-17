import 'package:delivoo/Components/progress_loader.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/WalletBloc/wallet_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/WalletBloc/wallet_event.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/WalletBloc/wallet_state.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Routes/routes.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/Themes/style.dart';
import 'package:delivoo/UtilityFunctions/app_settings.dart';
import 'package:delivoo/UtilityFunctions/get_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).wallet,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(fontWeight: FontWeight.w500)),
        titleSpacing: 0.0,
      ),
      body: BlocProvider<WalletBloc>(
        create: (context) => WalletBloc()..add(FetchWalletEvent()),
        child: WalletBody(),
      ),
    );
  }
}

class WalletBody extends StatefulWidget {
  @override
  _WalletBodyState createState() => _WalletBodyState();
}

class _WalletBodyState extends State<WalletBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        if (state is SuccessWalletState) {
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context)
                              .availableBalance
                              .toUpperCase(),
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              letterSpacing: 0.67,
                              color: kHintColor,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          AppSettings.currencyIcon +
                              ' ' +
                              state.walletBalance.balance.toStringAsFixed(2),
                          style: listTitleTextStyle.copyWith(
                              fontSize: 35.0,
                              color: kMainColor,
                              letterSpacing: 0.18),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 40.0,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    color: Theme.of(context).cardColor,
                    child: Text(
                      AppLocalizations.of(context).recent,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                          color: kTextColor,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.08),
                    ),
                  ),
                  if (state.walletTransactions != null)
                    if (state.walletTransactions.isNotEmpty)
                      ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.walletTransactions.length,
                          itemBuilder: (context, index) {
                            var transaction = state.walletTransactions[index];
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0, top: 10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(transaction.meta.description,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          SizedBox(height: 10.0),
                                          Text(transaction.createdAtFormatted,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                      color: kTextColor,
                                                      fontSize: 11.7)),
                                        ],
                                      ),
                                      Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            '${AppSettings.currencyIcon} ${transaction.amount}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xffe32a2a)),
                                          ),
                                          SizedBox(height: 10.0),
                                          Text(
                                              '${transaction.type} ' +
                                                  AppLocalizations.of(context)
                                                      .getTranslationOf(
                                                          'items'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                      color: kTextColor,
                                                      fontSize: 11.7)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Theme.of(context).cardColor,
                                  thickness: 3.0,
                                ),
                              ],
                            );
                          })
                    else
                      Expanded(
                        child: Center(
                          child: Text(AppLocalizations.of(context)
                              .getTranslationOf("noTransactions")),
                        ),
                      )
                ],
              ),
              Positioned.directional(
                textDirection: Directionality.of(context),
                top: 70.0,
                end: 20.0,
                child: Container(
                  height: 46.0,
                  width: 134.0,
                  color: kMainColor,
                  child: FlatButton(
                    color: kMainColor,
                    onPressed: () => Navigator.pushNamed(
                            context, PageRoutes.addMoney,
                            arguments: state.walletBalance.balance)
                        .then((value) {
                      if (value != null && value == true) {
                        BlocProvider.of<WalletBloc>(context)
                            .add(FetchWalletEvent());
                      }
                    }),
                    child: Text(
                      AppLocalizations.of(context).addMoney,
                      style: bottomBarTextStyle.copyWith(
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (state is FailureWalletState) {
          return Center(
            child: Text(AppLocalizations.of(context).networkError),
          );
        } else {
          return ProgressLoader();
        }
      },
    );
  }
}
