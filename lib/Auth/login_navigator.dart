import 'package:delivoo/Auth/MobileNumber/UI/login_page.dart';
import 'package:delivoo/Auth/Registration/UI/register_page.dart';
import 'package:delivoo/Auth/Social/UI/social_sign_up.dart';
import 'package:delivoo/Auth/Verification/UI/verification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'BLOC/auth_bloc.dart';
import 'BLOC/auth_event.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class LoginRoutes {
  static const String loginRoot = 'login/';
  static const String registration = 'login/registration';
  static const String verification = 'login/verification';
  static const String socialSignUp = 'login/social';
}

class LoginData {
  final String phoneNumber;
  final String name;
  final String email;

  LoginData(this.phoneNumber, this.name, this.email);
}

class LoginNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var canPop = navigatorKey.currentState.canPop();
        if (canPop) {
          navigatorKey.currentState.pop();
        }
        return !canPop;
      },
      child: Navigator(
        key: navigatorKey,
        initialRoute: LoginRoutes.loginRoot,
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case LoginRoutes.loginRoot:
              builder = (BuildContext _) => LoginPage(
                    onRegistrationDone: () {
                      BlocProvider.of<AuthBloc>(context).add(LoggedIn());
                      Phoenix.rebirth(context);
                    },
                  );
              break;
            case LoginRoutes.registration:
              builder = (BuildContext _) =>
                  RegisterPage(settings.arguments as String);
              break;
            case LoginRoutes.verification:
              LoginData loginData = settings.arguments as LoginData;
              builder = (BuildContext _) => VerificationPage(
                    loginData.phoneNumber,
                    loginData.name,
                    loginData.email,
                    () {
                      BlocProvider.of<AuthBloc>(context).add(LoggedIn());
                      Phoenix.rebirth(context);
                    },
                  );
              break;
            case LoginRoutes.socialSignUp:
              builder = (BuildContext _) => SocialLoginPage();
              break;
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
        onPopPage: (Route<dynamic> route, dynamic result) {
          return route.didPop(result);
        },
      ),
    );
  }
}
