import 'package:delivoo/Components/animated_bottom_bar.dart';
import 'package:delivoo/HomeOrderAccount/Account/UI/account_page.dart';
import 'package:delivoo/HomeOrderAccount/Home/UI/home_page.dart';
import 'package:delivoo/HomeOrderAccount/Order/UI/list_of_order_page.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeOrderAccount extends StatefulWidget {
  final index;

  HomeOrderAccount(this.index);

  @override
  _HomeOrderAccountState createState() => _HomeOrderAccountState();
}

class _HomeOrderAccountState extends State<HomeOrderAccount> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
  }

  void onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  static String bottomIconHome = 'images/footermenu/ic_home.png';

  static String bottomIconOrder = 'images/footermenu/ic_orders.png';

  static String bottomIconAccount = 'images/footermenu/ic_profile.png';

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context);
    final List<BarItem> barItems = [
      BarItem(
        text: appLocalization.getTranslationOf("address_type_home"),
        image: bottomIconHome,
      ),
      BarItem(
        text: appLocalization.orderText,
        image: bottomIconOrder,
      ),
      BarItem(
        text: appLocalization.account,
        image: bottomIconAccount,
      ),
    ];

    final List<Widget> _children = [
      HomePage(),
      OrderPage(),
      AccountPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: AnimatedBottomBar(
          barItems: barItems,
          selectedBarIndex: _currentIndex,
          onBarTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          }),
    );
  }
}
