import 'package:delivoo/Auth/BLOC/auth_bloc.dart';
import 'package:delivoo/Auth/BLOC/auth_event.dart';
import 'package:delivoo/Auth/BLOC/auth_state.dart';
import 'package:delivoo/Components/cached_image.dart';
import 'package:delivoo/Components/list_tile.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/AccountBloc/account_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/AccountBloc/account_event.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/AccountBloc/account_state.dart';
import 'package:delivoo/HomeOrderAccount/Account/UI/ListItems/profile_page.dart';
import 'package:delivoo/JsonFiles/Auth/Responses/user_info.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Routes/routes.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).account,
            style: Theme.of(context).textTheme.bodyText1),
        centerTitle: true,
      ),
      body: BlocProvider<AccountBloc>(
        create: (BuildContext context) => AccountBloc()..add(FetchEvent()),
        child: Account(),
      ),
    );
  }
}

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String number;

  AccountBloc _accountBloc;
  UserInformation _userInformation;

  @override
  void initState() {
    super.initState();
    _accountBloc = BlocProvider.of<AccountBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      // condition: (previous, current) {
      //   return previous is Unauthenticated && current is Authenticated;
      // },
      listener: (context, state) {
        _accountBloc.add(FetchEvent());
      },
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          BlocListener<AccountBloc, AccountState>(
            listener: (context, state) {
              if (state is SuccessState) {
                _userInformation = state.userInformation;
                setState(() {});
              }
            },
            child: _userInformation == null
                ? Container(
                    height: 75.0,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()),
                        ).then((value) {
                          if (value != null && value is UserInformation) {
                            _userInformation = value;
                            setState(() {});
                          }
                        }),
                        child: UserDetails(_userInformation),
                      ),
                      Divider(
                        color: kCardBackgroundColor,
                        thickness: 8.0,
                        height: 24,
                      ),
                      BuildListTile(
                        image: 'images/account/ic_menu_addressact.png',
                        text: AppLocalizations.of(context).saved,
                        onTap: () => Navigator.pushNamed(
                            context, PageRoutes.savedAddressesPage),
                      ),
                      BuildListTile(
                        image: 'images/account/ic_menu_wallet.png',
                        text: AppLocalizations.of(context).wallet,
                        onTap: () async {
                          try {
                            Navigator.pushNamed(context, PageRoutes.wallet);
                          } catch (e) {
                            return;
                          }
                        },
                      ),
                      BuildListTile(
                        image: 'images/account/ic_menu_offer.png',
                        text: AppLocalizations.of(context)
                            .getTranslationOf('offers'),
                        onTap: () async {
                          try {
                            Navigator.pushNamed(context, PageRoutes.offersPage);
                          } catch (e) {
                            return;
                          }
                        },
                      ),
                      BuildListTile(
                          image: 'images/account/ic_menu_supportact.png',
                          text: AppLocalizations.of(context).support,
                          onTap: () => Navigator.pushNamed(
                              context, PageRoutes.supportPage)),
                    ],
                  ),
          ),
          BuildListTile(
              image: 'images/account/ic_menu_tncact.png',
              text: AppLocalizations.of(context).tnc,
              onTap: () => Navigator.pushNamed(context, PageRoutes.tncPage)),
          BuildListTile(
            image: 'images/account/ic_menu_setting.png',
            text: AppLocalizations.of(context).settings,
            onTap: () => Navigator.pushNamed(context, PageRoutes.settings),
          ),
          BlocBuilder<AccountBloc, AccountState>(
            builder: (context, state) {
              return LogoutTile(state);
            },
          ),
        ],
      ),
    );
  }
}

class LogoutTile extends StatelessWidget {
  final AccountState state;
  LogoutTile(this.state);
  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    if (state is SuccessState) {
      return BuildListTile(
        image: 'images/account/ic_menu_logoutact.png',
        text: AppLocalizations.of(context).logout,
        onTap: () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context).loggingOut),
                  content: Text(AppLocalizations.of(context).areYouSure),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(AppLocalizations.of(context).no),
                      textColor: kMainColor,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: kTransparentColor)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    FlatButton(
                        child: Text(AppLocalizations.of(context).yes),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: kTransparentColor)),
                        textColor: kMainColor,
                        onPressed: () {
                          Navigator.pop(context);
                          BlocProvider.of<AuthBloc>(context).add(LoggedOut());
                        })
                  ],
                );
              });
        },
      );
    } else
      return BuildListTile(
        image: 'images/account/ic_menu_logoutact.png',
        text: AppLocalizations.of(context).login,
        onTap: () {
          Navigator.pushNamed(context, PageRoutes.loginNavigator);
        },
      );
  }
}

class UserDetails extends StatelessWidget {
  final UserInformation userInfo;

  const UserDetails(this.userInfo);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: getImage() != null
                  ? CachedImage(getImage(), height: 60, width: 60)
                  : Image(
                      fit: BoxFit.fill,
                      height: 60,
                      width: 60,
                      image: AssetImage('images/empty_dp.png'),
                    ),
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('\n' + userInfo.name,
                    style: Theme.of(context).textTheme.bodyText1),
                Text('\n' + userInfo.mobileNumber,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: Color(0xff9a9a9a))),
                SizedBox(height: 5.0),
                Text(userInfo.email,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: Color(0xff9a9a9a))),
              ],
            ),
          ],
        ));
  }

  String getImage() {
    return userInfo?.mediaUrls?.images?.first?.defaultImage;
  }
}
