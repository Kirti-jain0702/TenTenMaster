import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Components/entry_field.dart';
import 'package:delivoo/Components/show_toast.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/WalletBloc/wallet_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/WalletBloc/wallet_event.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/WalletBloc/wallet_state.dart';
import 'package:delivoo/JsonFiles/PaymentMethod/payment_method.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/Themes/style.dart';
import 'package:delivoo/UtilityFunctions/app_settings.dart';
import 'package:delivoo/UtilityFunctions/card_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddMoneyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double balance = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).addMoney,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(fontWeight: FontWeight.w500)),
        titleSpacing: 0.0,
      ),
      body: BlocProvider<WalletBloc>(
        create: (context) => WalletBloc(),
        child: AddMoneyBody(balance),
      ),
    );
  }
}

class AddMoneyBody extends StatefulWidget {
  final double balance;

  AddMoneyBody(this.balance);

  @override
  _AddMoneyBodyState createState() => _AddMoneyBodyState();
}

class _AddMoneyBodyState extends State<AddMoneyBody> {
  // TextEditingController _nameController = TextEditingController();
  // TextEditingController _bankNameController = TextEditingController();
  // TextEditingController _branchController = TextEditingController();
  // TextEditingController _numberController = TextEditingController();
  // TextEditingController _amountController =
  //     TextEditingController(text: '${AppSettings.currencyIcon} ');
  TextEditingController _amountController = TextEditingController();
  PaymentMethod selectedValue;
  bool isLoaderShowing = false;

  @override
  void dispose() {
    _amountController?.dispose();
    // _nameController?.dispose();
    // _bankNameController?.dispose();
    // _branchController?.dispose();
    // _numberController?.dispose();
    // _amountController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - 84,
        child: BlocListener<WalletBloc, WalletState>(
          listener: (context, state) {
            if (state is LoadingWalletState) {
              showLoader();
            } else {
              dismissLoader();
            }
            if (state is WalletRechargeState) {
              Navigator.pop(context, state.paid);
            }
          },
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .availableBalance
                                .toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    letterSpacing: 0.67,
                                    color: kHintColor,
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          '${AppSettings.currencyIcon} ${widget.balance.toStringAsFixed(2)}',
                          style: listTitleTextStyle.copyWith(
                              fontSize: 35.0,
                              color: kMainColor,
                              letterSpacing: 0.18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                color: Theme.of(context).cardColor,
                thickness: 8.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          AppLocalizations.of(context).amount.toUpperCase(),
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.67,
                              color: kHintColor),
                        ),
                      ),
                    ),
                    EntryField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      label: AppLocalizations.of(context)
                          .getTranslationOf("enter_amount"),
                    ),
                    // EntryField(
                    //   controller: _bankNameController,
                    //   textCapitalization: TextCapitalization.words,
                    //   label: AppLocalizations.of(context).bankName.toUpperCase(),
                    // ),
                    // EntryField(
                    //   controller: _branchController,
                    //   textCapitalization: TextCapitalization.none,
                    //   label:
                    //       AppLocalizations.of(context).branchCode.toUpperCase(),
                    // ),
                    // EntryField(
                    //   controller: _numberController,
                    //   textCapitalization: TextCapitalization.none,
                    //   label: AppLocalizations.of(context)
                    //       .accountNumber
                    //       .toUpperCase(),
                    // ),
                  ],
                ),
              ),
              Divider(
                color: Theme.of(context).cardColor,
                thickness: 8.0,
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 12.0),
              //   child: EntryField(
              //     controller: _amountController,
              //     textCapitalization: TextCapitalization.words,
              //     label: AppLocalizations.of(context)
              //         .enterAmountToTransfer
              //         .toUpperCase(),
              //   ),
              // ),
              // BlocBuilder<PaymentBloc, PaymentState>(
              //   builder: (context, state) {
              //     if (state is SuccessPaymentState) {
              //       return Padding(
              //         padding: EdgeInsets.all(20.0),
              //         child: DropdownButtonFormField(
              //           hint: Text(AppLocalizations.of(context).selectPayment),
              //           items: state.listOfPaymentMethods
              //               .map((e) => DropdownMenuItem(
              //                     child: Text(e.title),
              //                     value: e,
              //                   ))
              //               .toList(),
              //           value: selectedValue,
              //           onChanged: (value) {
              //             setState(() {
              //               selectedValue = value;
              //             });
              //           },
              //         ),
              //       );
              //     } else {
              //       return SizedBox.shrink();
              //     }
              //   },
              // ),
              // Spacer(),
              BottomBar(
                text: AppLocalizations.of(context).addMoney,
                onTap: () async {
                  if (_amountController.text != null &&
                      _amountController.text.trim().isNotEmpty) {
                    CardInfo cardInfo = await CardPicker.getSavedCard();
                    CardPicker.pickCard(context, cardInfo, true).then((value) {
                      if (value != null && value is CardInfo)
                        BlocProvider.of<WalletBloc>(context).add(
                            DepositWalletEvent(_amountController.text.trim(),
                                "stripe", value));
                    });
                  } else {
                    showToast(AppLocalizations.of(context)
                        .getTranslationOf("enter_amount"));
                  }
                },
              ),
            ],
          ),
        ),
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
}
