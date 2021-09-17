import 'package:delivoo/Auth/BLOC/auth_bloc.dart';
import 'package:delivoo/Auth/BLOC/auth_event.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CartQuantityBloc/cart_quantity_bloc.dart';
import 'package:delivoo/HomeOrderAccount/home_order_account.dart';
import 'package:delivoo/Locale/language_cubit.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/OneSignal/one_signal.dart';
import 'package:delivoo/Routes/routes.dart';
import 'package:delivoo/SettingsBloc/settings_bloc.dart';
import 'package:delivoo/SettingsBloc/settings_event.dart';
import 'package:delivoo/Themes/theme_cubit.dart';
import 'package:delivoo/UtilityFunctions/bloc_delegate.dart';
import 'package:delivoo/splash_screen_seconday.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeOrderAccount/home_order_account.dart';
import 'SettingsBloc/settings_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocDelegate();
  await initOneSignal();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  final prefs = await SharedPreferences.getInstance();
  bool isDark = prefs.getBool('isDark');
  runApp(Phoenix(
      child: MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AppStarted())),
      BlocProvider<LanguageCubit>(
          create: (context) => LanguageCubit()..getCurrentLanguage()),
      BlocProvider<ThemeCubit>(create: (context) => ThemeCubit(isDark)),
      BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc()..add(FetchSettingsEvent())),
      BlocProvider<CartQuantityBloc>(create: (context) => CartQuantityBloc()),
    ],
    child: Delivoo(),
  )));
}

class Delivoo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (_, theme) {
        return BlocBuilder<LanguageCubit, Locale>(
          builder: (_, locale) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: [
                const AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.getSupportedLocales(),
              locale: locale,
              theme: theme,
              home: /*AWSCheckScreen()*/BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  if (state is SuccessSettingsState) {
                    return HomeOrderAccount(0);
                  } else if (state is FailureSettingsState) {
                    return TextOnlyScreen(AppLocalizations.of(context)
                        .getTranslationOf('turn_on_your_data'));
                  } else {
                    return SplashScreenSecondary();
                  }
                },
              ),
              routes: PageRoutes().routes(),
            );
          },
        );
      },
    );
  }
}
