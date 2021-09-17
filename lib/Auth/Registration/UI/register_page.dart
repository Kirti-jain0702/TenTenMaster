import 'package:delivoo/Auth/Registration/BLOC/register_bloc.dart';
import 'package:delivoo/Auth/Registration/BLOC/register_event.dart';
import 'package:delivoo/Auth/Registration/BLOC/register_state.dart';
import 'package:delivoo/Auth/login_navigator.dart';
import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Components/entry_field.dart';
import 'package:delivoo/Components/show_toast.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//register page for registration of a new user
class RegisterPage extends StatelessWidget {
  final String phoneNumber;

  RegisterPage(this.phoneNumber);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(AppLocalizations.of(context).register),
      ),

      //this column contains 3 textFields and a bottom bar
      body: BlocProvider<SignUpBloc>(
        create: (BuildContext context) => SignUpBloc(),
        child: RegisterForm(phoneNumber),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  final String phoneNumber;

  RegisterForm(this.phoneNumber);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  SignUpBloc _registerBloc;
  bool isLoaderShowing = false;

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<SignUpBloc>(context);
  }
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          showLoader();
        } else {
          dismissLoader();
        }
        if (state.isSuccess) {
          Navigator.pushNamed(context, LoginRoutes.verification,
              arguments: LoginData(widget.phoneNumber, _nameController.text,
                  _emailController.text));
        } else {
          if (state.isServerError) {
            showToast(AppLocalizations.of(context)
                .getTranslationOf("phone_email_taken"));
          } else if (!state.isNameValid) {
            showToast(AppLocalizations.of(context).invalidName);
          } else if (!state.isEmailValid) {
            showToast(AppLocalizations.of(context).invalidEmail);
          } else if (!state.isNameValid && !state.isEmailValid) {
            showToast(AppLocalizations.of(context).invalidNameAndEmail);
          }
        }
      },
      child: BlocBuilder<SignUpBloc, RegisterState>(builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  //name textField
                  EntryField(
                    controller: _nameController,
                    label: AppLocalizations.of(context).fullName,
                    image: 'images/icons/ic_name.png',
                  ),

                  //email textField
                  EntryField(
                    controller: _emailController,
                    label: AppLocalizations.of(context).emailAddress,
                    image: 'images/icons/ic_mail.png',
                    keyboardType: TextInputType.emailAddress,
                  ),

                  //phone textField
                  EntryField(
                    label: AppLocalizations.of(context).mobileNumber,
                    image: 'images/icons/ic_phone.png',
                    initialValue: widget.phoneNumber,
                    keyboardType: TextInputType.number,
                    readOnly: false,
                    onlyNumber: true,
                  ),

                  Text(
                    AppLocalizations.of(context).verificationText,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),

            //continue button bar
            BottomBar(
                text: AppLocalizations.of(context).continueText,
                onTap: () {
                  _onFormSubmitted();
                })
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

  void _onFormSubmitted() {
    _registerBloc.add(
      SubmittedEvent(
          name: _nameController.text,
          email: _emailController.text,
          phoneNumber: widget.phoneNumber),
    );
  }
}
