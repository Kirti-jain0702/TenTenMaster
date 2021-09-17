import 'package:delivoo/AppConfig/app_config.dart';
import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Locale/language_cubit.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/Themes/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeList {
  final String title;
  final String subtitle;

  ThemeList({this.title, this.subtitle});
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  LanguageCubit _languageCubit;
  ThemeCubit _themeCubit;
  String selectedTheme, selectedLocale;

  @override
  void initState() {
    _languageCubit = BlocProvider.of<LanguageCubit>(context);
    _themeCubit = BlocProvider.of<ThemeCubit>(context);
    getSettings();
    super.initState();
  }

  getSettings() async {
    var prefs = await SharedPreferences.getInstance();
    bool isDark = prefs.getBool('isDark');
    setState(() {
      selectedTheme = getTheme(isDark);
    });
  }

  String getTheme(bool isDark) {
    if (isDark == null) {
      return AppLocalizations.of(context).lightMode;
    } else if (isDark) {
      return AppLocalizations.of(context).darkMode;
    } else {
      return AppLocalizations.of(context).lightMode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<ThemeList> themes = <ThemeList>[
      ThemeList(
        title: AppLocalizations.of(context).lightMode,
        subtitle: AppLocalizations.of(context).lightText,
      ),
      ThemeList(
        title: AppLocalizations.of(context).darkMode,
        subtitle: AppLocalizations.of(context).darkText,
      ),
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(AppLocalizations.of(context).settings,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(fontWeight: FontWeight.w500)),
        titleSpacing: 0.0,
      ),
      body: Stack(
        children: [
          ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                //color: kCardBackgroundColor,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).display,
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: kTextColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.08),
                  ),
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: themes.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return RadioListTile(
                    value: themes[index].title,
                    title: Text(
                      themes[index].title,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    subtitle: Text(
                      themes[index].subtitle,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    groupValue: selectedTheme,
                    onChanged: (value) {
                      setState(() {
                        selectedTheme = value;
                      });
                    },
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).selectLanguage,
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: kTextColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.08),
                  ),
                ),
              ),
              BlocBuilder<LanguageCubit, Locale>(builder: (_, locale) {
                if (selectedLocale == null)
                  selectedLocale = locale.languageCode;
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: AppConfig.languagesSupported.length-1,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return RadioListTile(
                      value: AppConfig.languagesSupported.keys.elementAt(index),
                      groupValue: selectedLocale,
                      title: Text(
                        AppConfig
                            .languagesSupported[AppConfig
                                .languagesSupported.keys
                                .elementAt(index)]
                            .name,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedLocale = value;
                        });
                      },
                    );
                  },
                );
              }),
              SizedBox(
                height: 100,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomBar(
                text: AppLocalizations.of(context).continueText,
                onTap: () {
                  _languageCubit.setCurrentLanguage(selectedLocale, true);

                  if (selectedTheme == AppLocalizations.of(context).darkMode) {
                    _themeCubit.selectDarkTheme();
                  } else {
                    _themeCubit.selectLightTheme();
                  }

                  Navigator.pop(context);
                }),
          ),
        ],
      ),
    );
  }
}
