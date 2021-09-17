import 'package:delivoo/Auth/MobileNumber/BLOC/mobile_bloc.dart';
import 'package:delivoo/Auth/MobileNumber/BLOC/mobile_event.dart';
import 'package:delivoo/Auth/MobileNumber/BLOC/mobile_state.dart' as mobile;
import 'package:delivoo/Auth/MobileNumber/UI/login_interactor.dart';
import 'package:delivoo/Auth/MobileNumber/UI/login_ui.dart';
import 'package:delivoo/Auth/Social/SignIn/social_bloc.dart';
import 'package:delivoo/Auth/Social/SignIn/social_event.dart';
import 'package:delivoo/Auth/Social/SignIn/social_state.dart' as social;
import 'package:delivoo/Auth/login_navigator.dart';
import 'package:delivoo/Components/show_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback onRegistrationDone;

  LoginPage({this.onRegistrationDone});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MobileBloc>(
          create: (context) => MobileBloc(),
        ),
        BlocProvider<SocialLoginBloc>(
          create: (context) => SocialLoginBloc(),
        )
      ],
      child: LoginBody(onRegistrationDone),
    );
  }
}

class LoginBody extends StatefulWidget {
  final VoidCallback onRegistrationDone;

  LoginBody(this.onRegistrationDone);

  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> implements LoginInteractor {
  MobileBloc _mobileBloc;
  SocialLoginBloc _socialLoginBloc;

  @override
  void initState() {
    super.initState();
    _mobileBloc = BlocProvider.of<MobileBloc>(context);
    _socialLoginBloc = BlocProvider.of<SocialLoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<MobileBloc, mobile.MobileState>(
            listener: (BuildContext context, mobile.MobileState state) {
              mobile.Success success = state.success;
              if (success is mobile.SuccessInitialized) {
                Navigator.pop(context);
                goToNextScreenMobile(
                    success.isRegistered, success.normalizedPhoneNumber);
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
                showToast('Network error');
              } else if (success is mobile.SuccessUninitialized) {
                showToast('Invalid number');
              }
            },
          ),
          BlocListener<SocialLoginBloc, social.SocialLoginState>(
            listener: (BuildContext context, social.SocialLoginState state) {
              social.Success success = state.success;
              if (success is social.SuccessInitialized) {
                Navigator.pop(context);
                goToNextScreenSocial(success.isRegistered);
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
                // Navigator.pop(context);
                showToast('Network error');
              } else if (success is social.SuccessUninitialized) {
                showToast('Sign in failed');
              }
            },
          ),
        ],
        child: BlocBuilder<MobileBloc, mobile.MobileState>(
            builder: (context, state) {
          return LoginUI(this);
        }));
  }

  void goToNextScreenMobile(bool isRegistered, String normalizedPhoneNumber) {
    if (isRegistered) {
      Navigator.pushNamed(context, LoginRoutes.verification,
          arguments: LoginData(normalizedPhoneNumber, null, null));
    } else {
      Navigator.pushNamed(context, LoginRoutes.registration,
          arguments: normalizedPhoneNumber);
    }
  }

  void goToNextScreenSocial(bool isRegistered) {
    if (isRegistered) {
      widget.onRegistrationDone();
    } else {
      Navigator.pushNamed(context, LoginRoutes.socialSignUp);
    }
  }

  @override
  void loginWithFacebook() {
    _socialLoginBloc.add(LoginWithFacebookPressed());
  }

  @override
  void loginWithGoogle() {
    _socialLoginBloc.add(LoginWithGooglePressed());
  }

  @override
  void loginWithMobile(String isoCode, String mobileNumber) {
    _mobileBloc.add(SubmittedEvent(isoCode, mobileNumber));
  }

  @override
  void loginWithApple() {}
}
