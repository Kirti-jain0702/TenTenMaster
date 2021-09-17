import 'dart:convert';

import 'package:delivoo/Auth/BLOC/auth_bloc.dart';
import 'package:delivoo/Auth/BLOC/auth_state.dart';
import 'package:delivoo/Cart/view_cart.dart';
import 'package:delivoo/Components/custom_dialog.dart';
import 'package:delivoo/Components/search_bar.dart';
import 'package:delivoo/Components/show_toast.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/BannerBloc/Banner_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/BannerBloc/Banner_event.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/BannerBloc/Banner_state.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CartQuantityBloc/cart_quantity_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CartQuantityBloc/cart_quantity_state.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CategoryBloc/category_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CategoryBloc/category_event.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CategoryBloc/category_state.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/HomeBloc/home_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/HomeBloc/home_event.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/HomeBloc/home_state.dart';
import 'package:delivoo/HomeOrderAccount/Home/Components/category_grid_item.dart';
import 'package:delivoo/HomeOrderAccount/Home/LoadingPlaceHolders/home_place_holder.dart';
import 'package:delivoo/HomeOrderAccount/Home/UI/custom_delivery_page.dart';
import 'package:delivoo/Items/items_tab.dart';
import 'package:delivoo/JsonFiles/Products/product_data.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Maps/UI/location_page.dart';
import 'package:delivoo/Maps/location_selected.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/Themes/style.dart';
import 'package:delivoo/UtilityFunctions/HomeSliderLoaderWidget.dart';
import 'package:delivoo/UtilityFunctions/HomeSliderWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Stores/stores_page.dart';
import 'search_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (BuildContext context) => HomeBloc()
            ..add(GetCurrentAddressEvent(
                false)), //pass true for detection preservation.
        ),
        BlocProvider<CategoryBloc>(
          create: (BuildContext context) =>
              CategoryBloc()..add(FetchCategoryEvent()),
        ),
        BlocProvider<BannerBloc>(
          create: (BuildContext context) =>
              BannerBloc()..add(FetchBannerEvent()),
        )
      ],
      child: HomeBody(),
    );
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> with WidgetsBindingObserver {
  HomeBloc _homeBloc;


  getLatLng() async {
    await _homeBloc.getLatLng();
  }

  saveCart() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("cart_products", jsonEncode(cartProducts));
  }

  loadCart() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("cart_products")) {
      cartProducts = (jsonDecode(prefs.getString("cart_products")) as List)
          .map((e) => ProductData.fromJson(e as Map<String, dynamic>))
          .toList();
      cartProducts.forEach((element) {
        element.quantity = 1;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        loadCart();
        break;
      case AppLifecycleState.inactive:
        if (cartProducts.isNotEmpty) {
          saveCart();
        }
        break;
      case AppLifecycleState.paused:
        loadCart();
        break;
      case AppLifecycleState.detached:
        if (cartProducts.isNotEmpty) {
          saveCart();
        }
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      loadCart();
    });
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is RestartState) {
              Phoenix.rebirth(context);
            }
          },
        ),
        BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state.goToNextPage) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LocationPage(true))).then((value) {
                if (value != null && value is LocationSelected) {
                  _homeBloc.add(
                      GetCurrentAddressEvent(false, selectedLocation: value));
                } else {
                  _homeBloc.add(NoValueSelectedEvent());
                }
              });
            }
          },
        )
      ],
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Icon(
                  Icons.location_on,
                  color: kMainColor,
                ),
              ),
              title: buildDropdownButton(state),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Stack(
                    children: [
                      IconButton(
                        icon: ImageIcon(
                          AssetImage('images/icons/ic_cart blk.png'),
                        ),
                        onPressed: () {
                          if (cartProducts.isEmpty) {
                            showToast(AppLocalizations.of(context)
                                .getTranslationOf('cart_is_empty'));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ViewCart(() => Navigator.pop(context)),
                                ));
                          }
                        },
                      ),
                      BlocBuilder<CartQuantityBloc, CartQuantityState>(
                          builder: (context, cartState) {
                        return cartState.quantity > 0
                            ? PositionedDirectional(
                                end: 5,
                                top: 5,
                                child: CircleAvatar(
                                  radius: 7,
                                  backgroundColor: theme.primaryColor,
                                  child: Text(
                                    cartState.quantity.toString(),
                                    style: theme.textTheme.overline.copyWith(
                                        color: theme.scaffoldBackgroundColor,
                                        fontSize: 8),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : SizedBox.shrink();
                      })
                    ],
                  ),
                ),
              ],
            ),
            body: Column(
              children: <Widget>[

          /*      Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 24.0, bottom: 20.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).homeText1,
                        style: theme.textTheme.bodyText1,
                      ),
                      SizedBox(width: 6.0),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context).homeText2,
                          style: theme.textTheme.bodyText1
                              .copyWith(fontWeight: FontWeight.normal),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),*/
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        BlocBuilder<BannerBloc, BannerState>(
                          builder: (context, BannerState) {
                            if (BannerState is SuccessBannerState) {
                              return HomeSliderWidget(
                                  slides:
                                      BannerState.listOfBannerData.data);
                            } else if (BannerState is FailureBannerState) {
                              return Center(
                                  child: Text(AppLocalizations.of(context)
                                      .getTranslationOf(
                                          'check_your_network')));
                            } else {
                              return HomeSliderLoaderWidget();
                            }
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only( bottom: 26),
                          child: CustomSearchBar(
                              hint: AppLocalizations.of(context)
                                  .getTranslationOf('search_stores'),
                              readOnly: true,
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SearchPage.searchStores()))),
                        ),
                        BlocBuilder<CategoryBloc, CategoryState>(
                          builder: (context, categoryState) {
                            if (categoryState is SuccessCategoryState) {
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                   mainAxisSpacing: 10.0,
                                ),
                                itemCount:
                                    categoryState.listOfCategoryData.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  var category =
                                      categoryState.listOfCategoryData[index];
                                  return CategoryGridItem(category, () {
                                    if (category.slug
                                        .toLowerCase()
                                        .contains('custom')) {
                                      if (BlocProvider.of<AuthBloc>(context)
                                          .state is Authenticated)
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CustomDeliveryPage()));
                                      else
                                        showCustomDialog(context,
                                            content:
                                                AppLocalizations.of(context)
                                                    .login);
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => StoresPage(
                                                  category.title,
                                                  category.id)));
                                    }
                                  });
                                },
                              );
                            } else if (categoryState is FailureCategoryState) {
                              return Center(
                                  child: Text(AppLocalizations.of(context)
                                      .getTranslationOf(
                                          'check_your_network')));
                            } else {
                              return HomePlaceHolder();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  DropdownButton<String> buildDropdownButton(HomeState state) {
    return DropdownButton(
      value: state.selectedValue,
      isExpanded: true,
      icon: Icon(Icons.keyboard_arrow_down, color: kMainColor),
      iconSize: 24.0,
      elevation: 16,
      style: inputTextStyle.copyWith(fontWeight: FontWeight.bold),
      underline: Container(height: 0),
      onChanged: (String newValue) {
        _homeBloc.add(NewValueSelectedEvent(newValue));
      },
      items: state.addresses.map<DropdownMenuItem<String>>((String address) {
        return DropdownMenuItem<String>(
          value: address,
          child: Marquee(
            child: Text(
              AppLocalizations.of(context).getTranslationOf(address),
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _alertLocationServices() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)
                .getTranslationOf("location_disabled")),
            content: Text(AppLocalizations.of(context)
                .getTranslationOf("location_disabled_msg")),
            actions: <Widget>[
              FlatButton(
                child: Text(AppLocalizations.of(context).okay),
                textColor: kMainColor,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: kTransparentColor)),
                onPressed: () {
                  Navigator.pop(context);
                  _homeBloc.add(RequestLocationServicesEvent());
                },
              )
            ],
          );
        });
  }
}
