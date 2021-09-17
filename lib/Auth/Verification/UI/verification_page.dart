import 'package:delivoo/Auth/Verification/cubit/verification_cubit.dart';
import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Components/entry_field.dart';
import 'package:delivoo/Components/show_toast.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Verification page that sends otp to the phone number entered on phone number page
class VerificationPage extends StatelessWidget {
  final String phoneNumber;
  final String name;
  final String email;
  final VoidCallback onVerificationDone;

  VerificationPage(
      this.phoneNumber, this.name, this.email, this.onVerificationDone);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          AppLocalizations.of(context).verification,
          style: Theme.of(context).textTheme.caption.copyWith(fontSize: 16.7),
        ),
      ),
      body: BlocProvider<VerificationCubit>(
          create: (BuildContext context) => VerificationCubit(),
          child: OtpVerify(phoneNumber, name, email, onVerificationDone)),
    );
  }
}

//otp verification class
class OtpVerify extends StatefulWidget {
  final String phoneNumber;
  final String name;
  final String email;
  final VoidCallback onVerificationDone;

  OtpVerify(this.phoneNumber, this.name, this.email, this.onVerificationDone);

  @override
  _OtpVerifyState createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  final TextEditingController _controller = TextEditingController();
  bool isLoaderShowing = false;
  VerificationCubit _verificationCubit;
  AppLocalizations _locale;

  @override
  void initState() {
    super.initState();
    _verificationCubit = context.read<VerificationCubit>();
    _verificationCubit.initAuthentication(widget.phoneNumber);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _locale = AppLocalizations.of(context);
    return BlocListener<VerificationCubit, VerificationState>(
      listener: (context, state) {
        if (state is VerificationLoading) {
          showLoader();
        } else {
          dismissLoader();
        }
        if (state is VerificationSentLoaded) {
          showToast(_locale.getTranslationOf("code_sent"));
        } else if (state is VerificationVerifyingLoaded) {
          widget.onVerificationDone();
        } else if (state is VerificationError) {
          showToast(
              AppLocalizations.of(context).getTranslationOf(state.messageKey));
          if (state.messageKey == "something_wrong" ||
              state.messageKey == "role_exists") {
            Navigator.of(context).pop();
          }
        }
      },
      child: BlocBuilder<VerificationCubit, VerificationState>(
          builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).enterVerification,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 8.0, right: 60.0, top: 16.0, bottom: 8.0),
                    child: EntryField(
                      controller: _controller,
                      readOnly: false,
                      label: AppLocalizations.of(context).verificationCode,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     Padding(
            //       padding: EdgeInsets.only(left: 16.0),
            //       child: Text(
            //         '$_counter ' +
            //             AppLocalizations.of(context).getTranslationOf('sec'),
            //         style: Theme.of(context).textTheme.headline4,
            //       ),
            //     ),
            //     FlatButton(
            //         shape: RoundedRectangleBorder(side: BorderSide.none),
            //         padding: EdgeInsets.all(24.0),
            //         disabledTextColor: kDisabledColor,
            //         textColor: kMainColor,
            //         child: Text(
            //           AppLocalizations.of(context).resend,
            //           style: TextStyle(
            //             fontSize: 20.0,
            //           ),
            //         ),
            //         onPressed: () => _counter < 1
            //             ? () {
            //                 verifyPhoneNumber();
            //               }
            //             : null),
            //   ],
            // ),
            BottomBar(
                text: AppLocalizations.of(context).continueText,
                onTap: () {
                  if (_controller.text.trim().isNotEmpty)
                    _verificationCubit.verifyOtp(_controller.text.trim());
                }),
          ],
        );
      }),
    );
  }

  showLoader() {
    if (!isLoaderShowing) {
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
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
