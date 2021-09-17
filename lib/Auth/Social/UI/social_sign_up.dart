import 'package:country_code_picker/country_code_picker.dart';
import 'package:delivoo/Auth/Social/SignUp/ProfileBloc/profile_bloc.dart';
import 'package:delivoo/Auth/Social/SignUp/ProfileBloc/profile_event.dart';
import 'package:delivoo/Auth/Social/SignUp/ProfileBloc/profile_state.dart';
import 'package:delivoo/Auth/Social/SignUp/social_sign_up_bloc.dart';
import 'package:delivoo/Auth/Social/SignUp/social_sign_up_event.dart';
import 'package:delivoo/Auth/Social/SignUp/social_sign_up_state.dart';
import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Components/entry_field.dart';
import 'package:delivoo/Components/show_toast.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../login_navigator.dart';

class SocialLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SocialSignUpBloc>(
          create: (context) => SocialSignUpBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc()..add(FetchProfileEvent()),
        ),
      ],
      child: SocialLogin(),
    );
  }
}

class SocialLogin extends StatefulWidget {
  @override
  _SocialLoginState createState() => _SocialLoginState();
}

class _SocialLoginState extends State<SocialLogin> {
  final TextEditingController _controller = TextEditingController();

  SocialSignUpBloc _signUpBloc;
  ProfileBloc _profileBloc;
  String isoCode;

  @override
  void initState() {
    super.initState();
    _signUpBloc = BlocProvider.of<SocialSignUpBloc>(context);
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var theme = Theme.of(context);

    return BlocListener<SocialSignUpBloc, SocialSignUpState>(
        listener: (context, state) {
      _profileBloc.add(FetchProfileEvent());
      if (state.isSuccess) {
        Navigator.pop(context);
        Navigator.pushNamed(context, LoginRoutes.verification,
            arguments: LoginData(state.number, null, null /*, true*/));
      } else if (state.isSubmitting) {
        showDialog(
          context: context,
          barrierDismissible: false,
          useRootNavigator: false,
          builder: (BuildContext context) {
            return Center(child: CircularProgressIndicator());
          },
        );
      } else if (state.isFailure) {
        Navigator.pop(context);
        showToast(AppLocalizations.of(context)
            .getTranslationOf('phone_number_registered'));
      } else if (!state.isNumberValid) {
        showToast(
            AppLocalizations.of(context).getTranslationOf('invalid_number'));
      }
    }, child: BlocBuilder<SocialSignUpBloc, SocialSignUpState>(
            builder: (context, state) {
      return BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
        return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: AppBar(
                automaticallyImplyLeading: true,
              ),
            ),
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).hey +
                            ' ' +
                            profileState.name,
                        style:
                            theme.textTheme.headline4.copyWith(fontSize: 20.0),
                      ),
                      SizedBox(height: 60),
                      Text(
                        AppLocalizations.of(context)
                            .youAreAlmost
                            .split('. ')
                            .join('.\n'),
                        style:
                            theme.textTheme.headline4.copyWith(fontSize: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Row(
                          children: <Widget>[
                            CountryCodePicker(
                              onChanged: (value) {
                                isoCode = value.code;
                              },
                              builder: (value) => Padding(
                                padding: EdgeInsets.only(bottom: 7.0),
                                child: Text(
                                  '$value',
                                  style: theme.textTheme.subtitle2.copyWith(
                                      color: theme.secondaryHeaderColor),
                                ),
                              ),
                              initialSelection: '+91',
                              textStyle: theme.textTheme.caption,
                              showFlag: false,
                              showFlagDialog: true,
                              favorite: ['+91', '+65', 'US'],
                            ),

                            //takes phone number as input
                            Expanded(
                              child: EntryField(
                                controller: _controller,
                                keyboardType: TextInputType.number,
                                readOnly: false,
                                hint: locale.mobileText,
                                border: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 44.0),
                        child: Text(
                          AppLocalizations.of(context).verificationText,
                          style: theme.textTheme.headline6
                              .copyWith(fontSize: 12.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomBar(
                      text: AppLocalizations.of(context).continueText,
                      onTap: () => _signUpBloc.add(
                            SocialSignUpSubmittedEvent(
                                isoCode: isoCode,
                                mobileNumber: _controller.text,
                                name: profileState.name,
                                email: profileState.email),
                          )),
                )
              ],
            ));
      });
    }));
  }
}
