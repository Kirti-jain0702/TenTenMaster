import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Components/cached_image.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CartQuantityBloc/cart_quantity_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CartQuantityBloc/cart_quantity_event.dart';
import 'package:delivoo/JsonFiles/Products/product_data.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Routes/routes.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/UtilityFunctions/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Bloc/items_bloc.dart';
import 'Bloc/items_event.dart';
import 'Bloc/items_state.dart';

List<ProductData> cartProducts = [];

class ItemsTab extends StatelessWidget {
  final int vendorId;
  final int categoryId;
  final String vendorName;

  ItemsTab(this.vendorId, this.categoryId, this.vendorName);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ItemsBloc>(
        create: (BuildContext context) =>
            ItemsBloc(vendorId, categoryId)..add(FetchItemsEvent()),
        child: ItemsTabBody(vendorName));
  }
}

class ItemsTabBody extends StatefulWidget {
  final String vendorName;

  const ItemsTabBody(this.vendorName);

  @override
  _ItemsTabBodyState createState() => _ItemsTabBodyState();
}

class _ItemsTabBodyState extends State<ItemsTabBody> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CartQuantityBloc>(context).add(GetCartQuantityEvent());
    var theme = Theme.of(context);
    return BlocBuilder<ItemsBloc, ItemsState>(
      builder: (context, state) {
        if (state is SuccessItemsState) {
          if (state.products.length == 0 || state.products == null) {
            return Center(
              child: Text(AppLocalizations.of(context)
                  .getTranslationOf('no_items_found_in_this_store')),
            );
          } else
            return Stack(
              children: [
                ListView.builder(
                  padding: EdgeInsets.only(bottom: 80),
                  physics: BouncingScrollPhysics(),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    var product = state.products[index];
                    if (cartProducts.isNotEmpty &&
                        cartProducts
                            .any((element) => element.id == product.id)) {
                      var cartProduct = cartProducts
                          .singleWhere((element) => element.id == product.id);
                      product.quantity = cartProduct.quantity;
                    } else {
                      product.quantity = 0;
                    }
                    return Container(
                      height: MediaQuery.of(context).size.width / 4,
                      margin:
                          EdgeInsets.only(bottom: 12.0, left: 16, right: 16),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return Container(
                                      height: 650.0,
                                      child: BottomSheetWidget(product));
                                },
                              ).then((value) {
                                if (value != null) {
                                  if (value == "increment") {
                                    addProductConfirm(product);
                                  } else if (value == "decrement") {
                                    product.quantity--;
                                    if (product.quantity < 1) {
                                      cartProducts.removeWhere((element) =>
                                          element.id == product.id);
                                    }
                                    setState(() {});
                                  }
                                }
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CachedImage(
                                  product
                                      .mediaUrls?.images?.first?.defaultImage,
                                  height: MediaQuery.of(context).size.width / 4,
                                  width: MediaQuery.of(context).size.width / 4,
                                  radius: 6,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 6),
                                      Text(product.title,
                                          style: theme.textTheme.headline2
                                              .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600)),
                                      SizedBox(height: 6),
                                      Text(
                                          '${AppSettings.currencyIcon}  ' +
                                              product.price.toStringAsFixed(2),
                                          style: theme.textTheme.caption),
                                      Spacer(),
                                      SizedBox(height: 6),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (product.quantity == 0)
                            PositionedDirectional(
                              bottom: 30,
                              end: 10,
                              child: Container(
                                height: 35.0,
                                child: FlatButton(
                                  child: Text(
                                    AppLocalizations.of(context).add,
                                    style: theme.textTheme.caption.copyWith(
                                        color: theme.primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  textTheme: ButtonTextTheme.accent,
                                  onPressed: () => addProductConfirm(product),
                                ),
                              ),
                            )
                          else
                            PositionedDirectional(
                              bottom: 30,
                              end: 10,
                              child: Container(
                                height: 30.0,
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: theme.primaryColor),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        product.quantity--;
                                        if (product.quantity < 1) {
                                          cartProducts.removeWhere((element) =>
                                              element.id == product.id);
                                        }
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.remove,
                                        color: theme.primaryColor,
                                        size: 20.0,
                                      ),
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(product.quantity.toString(),
                                        style: theme.textTheme.caption),
                                    SizedBox(width: 8.0),
                                    InkWell(
                                      onTap: () {
                                        product.quantity++;
                                        cartProducts.removeWhere((element) =>
                                            element.id == product.id);
                                        cartProducts.add(product);
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.add,
                                        color: theme.primaryColor,
                                        size: 20.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                cartProducts.length > 0
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                'images/icons/ic_cart wt.png',
                                height: 19.0,
                                width: 18.3,
                              ),
                              SizedBox(width: 10),
                              Text(
                                '${cartProducts.length} ' +
                                    AppLocalizations.of(context)
                                        .getTranslationOf('items') +
                                    '  |  ${AppSettings.currencyIcon} ${getTotal().toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(color: Colors.white),
                              ),
                              Spacer(),
                              FlatButton(
                                color: Colors.white,
                                onPressed: () async {
                                  var prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString(
                                      'vendorName', widget.vendorName);
                                  Navigator.pushNamed(
                                          context, PageRoutes.checkout)
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  AppLocalizations.of(context).viewCart,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                          color: kMainColor,
                                          fontWeight: FontWeight.bold),
                                ),
                                textTheme: ButtonTextTheme.accent,
                                disabledColor: Colors.white,
                              ),
                            ],
                          ),
                          color: kMainColor,
                          height: 60.0,
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            );
        } else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }

  addProductConfirm(ProductData product) {
    bool conflicts = false;
    if (cartProducts.isNotEmpty) {
      for (ProductData productData in cartProducts) {
        if (productData.vendorProducts.first.vendorId !=
            product.vendorProducts.first.vendorId) {
          conflicts = true;
          break;
        }
      }
    }
    if (conflicts) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)
                      .getTranslationOf("cart_conflict_title")),
                  content: Text(AppLocalizations.of(context)
                      .getTranslationOf("cart_conflict_message")),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(AppLocalizations.of(context).no)),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(AppLocalizations.of(context).yes))
                  ])).then((value) {
        if (value != null && value == true) {
          cartProducts.clear();
          product.quantity = 1;
          cartProducts.add(product);
          setState(() {});
        }
      });
    } else {
      product.quantity++;
      cartProducts.add(product);
      setState(() {});
    }
  }
}

double getTotal() {
  double total = 0;
  for (var product in cartProducts) {
    total += product.quantity * product.price;
  }
  return total;
}

class BottomSheetWidget extends StatelessWidget {
  final ProductData product;

  BottomSheetWidget(this.product);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 250,
                  color: Theme.of(context).cardColor,
                  padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 30.0),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 6),
                        title: Text(product.title,
                            style: Theme.of(context).textTheme.caption.copyWith(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                        subtitle: Text(
                            product.categories
                                .map((e) => e.title)
                                .toList()
                                .join(', '),
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(fontSize: 15)),
                        trailing: product.quantity == null ||
                                product.quantity < 1
                            ? Container(
                                height: 30.0,
                                child: FlatButton(
                                  child: Text(
                                    AppLocalizations.of(context).add,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  textTheme: ButtonTextTheme.accent,
                                  onPressed: () =>
                                      Navigator.pop(context, "increment"),
                                ),
                              )
                            : Container(
                                height: 30.0,
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () =>
                                          Navigator.pop(context, "decrement"),
                                      child: Icon(
                                        Icons.remove,
                                        color: Theme.of(context).primaryColor,
                                        size: 16.0,
                                      ),
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(product.quantity.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                    SizedBox(width: 8.0),
                                    InkWell(
                                      onTap: () =>
                                          Navigator.pop(context, "increment"),
                                      child: Icon(
                                        Icons.add,
                                        color: Theme.of(context).primaryColor,
                                        size: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        height: 70,
                        child: Text(
                          product.detail,
                          style: Theme.of(context).textTheme.caption,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 220,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedImage(
                        product.mediaUrls?.images?.first?.defaultImage,
                        height: MediaQuery.of(context).size.height / 6,
                        width: MediaQuery.of(context).size.height / 6,
                        fit: BoxFit.fill,
                      )))
            ],
          ),
        ),
        BottomBar(
            onTap: () => Navigator.pop(context),
            text: AppLocalizations.of(context).close)
      ],
    );
  }
}
