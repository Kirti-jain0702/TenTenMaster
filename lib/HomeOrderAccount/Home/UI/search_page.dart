import 'dart:async';

import 'package:delivoo/Auth/BLOC/auth_bloc.dart';
import 'package:delivoo/Auth/BLOC/auth_state.dart';
import 'package:delivoo/Components/cached_image.dart';
import 'package:delivoo/Components/custom_appbar.dart';
import 'package:delivoo/Components/custom_dialog.dart';
import 'package:delivoo/Components/error_final_widget.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CartQuantityBloc/cart_quantity_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CartQuantityBloc/cart_quantity_event.dart';
import 'package:delivoo/HomeOrderAccount/Home/Components/store_list.dart';
import 'package:delivoo/HomeOrderAccount/Home/LoadingPlaceHolders/store_place_holder.dart';
import 'package:delivoo/HomeOrderAccount/Home/SearchBloc/search_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Home/SearchBloc/search_event.dart';
import 'package:delivoo/HomeOrderAccount/Home/SearchBloc/search_state.dart';
import 'package:delivoo/Items/items_tab.dart';
import 'package:delivoo/JsonFiles/Products/product_data.dart';
import 'package:delivoo/JsonFiles/Vendors/vendor_data.dart';
import 'package:delivoo/JsonFiles/base_list_response.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/UtilityFunctions/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class SearchPage extends StatelessWidget {
  String _searchType = "store";
  int _vendorId, _categoryId;

  SearchPage.searchStores({int categoryId}) {
    _searchType = "store";
    _categoryId = categoryId;
  }

  SearchPage.searchProducts([this._vendorId]) {
    _searchType = "product";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(),
      child: SearchBody(_searchType, this._vendorId, this._categoryId),
    );
  }
}

class SearchBody extends StatefulWidget {
  final String _searchType;
  final int _vendorId, _categoryId;

  SearchBody(this._searchType, this._vendorId, this._categoryId);

  @override
  _SearchBodyState createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  String _query;
  SearchBloc _searchBloc;
  Timer _debounce;
  ThemeData theme;
  TextEditingController _textEditingController;
  List<Vendor> _vendors = [];
  List<ProductData> _products = [];
  int _page = 1;
  bool _doneAll = false, _isLoading = false;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _searchBloc = BlocProvider.of<SearchBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    BlocProvider.of<CartQuantityBloc>(context).add(GetCartQuantityEvent());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(114.0),
        child: CustomAppBar(
          searchBarController: _textEditingController,
          autofocus: true,
          titleWidget: Text(
            AppLocalizations.of(context).getTranslationOf("search_title"),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          hint: AppLocalizations.of(context).getTranslationOf(
              widget._searchType == "store" ? "search_stores" : "search_item"),
          onSubmitted: (s) => _onSubmitted(s.trim()),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          _isLoading = state is LoadingSearch;
          if (state is LoadedSearch) {
            if (state.searchResult.meta.current_page == 1) {
              if (state.searchResult is BaseListResponse<Vendor>) {
                _vendors = state.searchResult.data;
              } else {
                _products = state.searchResult.data;
              }
            } else {
              if (state.searchResult is BaseListResponse<Vendor>) {
                _vendors.addAll(state.searchResult.data as List<Vendor>);
              } else {
                _products.addAll(state.searchResult.data as List<ProductData>);
              }
            }
            _page = state.searchResult.meta.current_page;
            _doneAll = state.searchResult.meta.current_page ==
                state.searchResult.meta.last_page;
          }
          if (_isLoading && _isListEmpty())
            return StorePlaceHolder();
          else if (!_isListEmpty())
            return ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 20.0, top: 20.0),
                  child: Text(
                    '${widget._searchType == "store" ? _vendors.length : _products.length} ' +
                        AppLocalizations.of(context).getTranslationOf(
                            widget._searchType == "store"
                                ? "storeFound"
                                : "products"),
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: kHintColor),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 20),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: (widget._searchType == "store"
                        ? _vendors.length
                        : _products.length),
                    itemBuilder: (context, index) {
                      if (!_doneAll && !_isLoading) {
                        if (widget._searchType == "store" &&
                            index == _vendors.length - 1) {
                          _searchBloc.add(SearchVendorsEvent(
                              _query, widget._categoryId, _page + 1));
                        }
                        if (widget._searchType == "product" &&
                            index == _products.length - 1) {
                          _searchBloc.add(SearchProductsEvent(
                              widget._vendorId, _query, _page + 1));
                        }
                      }

                      if (widget._searchType == "store") {
                        return StoreCard(_vendors[index]);
                      } else {
                        if (cartProducts.isNotEmpty &&
                            cartProducts.any((element) =>
                                element.id == _products[index].id)) {
                          var cartProduct = cartProducts.singleWhere(
                              (element) => element.id == _products[index].id);
                          _products[index].quantity = cartProduct.quantity;
                        }
                        return itemCard(_products[index]);
                      }
                    }),
              ],
            );
          else if (state is LoadedSearch)
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ErrorFinalWidget.errorWithRetry(
                context,
                AppLocalizations.of(context).getTranslationOf("empty_results"),
                null,
                null,
              ),
            );
          else
            return SizedBox.shrink();
        },
      ),
    );
  }

  _onSubmitted(String query) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 1500), () {
      if (_query == null || _query != query) {
        _query = query;
        _products.clear();
        _vendors.clear();
        if (_query.length > 0) {
          _searchBloc.add(widget._searchType == "store"
              ? SearchVendorsEvent(_query, widget._categoryId, 1)
              : SearchProductsEvent(widget._vendorId, _query, 1));
        } else {
          _textEditingController.clear();
          BlocProvider.of<SearchBloc>(context).add(SearchClearEvent());
        }
      }
      FocusScopeNode currentFocus = FocusScope.of(context);
      currentFocus.unfocus();
    });
  }

  Widget itemCard(ProductData product) {
    return Container(
      height: MediaQuery.of(context).size.width / 4,
      margin: EdgeInsets.only(bottom: 12.0, left: 16, right: 16),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (product.mediaUrls.images != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CachedImage(
                    product.mediaUrls?.images?.first?.defaultImage,
                    height: MediaQuery.of(context).size.width / 4,
                    width: MediaQuery.of(context).size.width / 4,
                  ),
                )
              else
                Image.asset(
                  'images/download.png',
                  height: 70,
                  width: 70,
                ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 6),
                    Text(product.title,
                        style: theme.textTheme.headline2.copyWith(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                    SizedBox(height: 6),
                    Text(
                        '${AppSettings.currencyIcon}  ' +
                            product.price.toStringAsFixed(2),
                        style: theme.textTheme.caption),
                    Spacer(),
                    // InkWell(
                    //   onTap: () {
                    //     showModalBottomSheet(
                    //       context: context,
                    //       builder: (context) {
                    //         return Container(
                    //             height: 280.0, child: BottomSheetWidget(product));
                    //       },
                    //     );
                    //   },
                    //   child: Container(
                    //     height: 30.0,
                    //     padding: EdgeInsets.symmetric(horizontal: 12.0),
                    //     decoration: BoxDecoration(
                    //       color: Theme.of(context).cardColor,
                    //       borderRadius: BorderRadius.circular(30.0),
                    //     ),
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: <Widget>[
                    //         Text(
                    //           'N/A',
                    //           // state
                    //           //     .listOfProductData[index]
                    //           //     .addOnGroups[0]
                    //           //     .addOnChoices[0]
                    //           //     .title,
                    //           style: Theme.of(context).textTheme.caption,
                    //         ),
                    //         SizedBox(width: 8.0),
                    //         Icon(
                    //           Icons.keyboard_arrow_down,
                    //           color: kMainColor,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 6),
                  ],
                ),
              ),
            ],
          ),
          if (product.quantity == 0)
            PositionedDirectional(
              bottom: 0,
              end: 16,
              child: Container(
                height: 30.0,
                child: FlatButton(
                  child: Text(
                    AppLocalizations.of(context).add,
                    style: theme.textTheme.caption.copyWith(
                        color: theme.primaryColor, fontWeight: FontWeight.bold),
                  ),
                  textTheme: ButtonTextTheme.accent,
                  onPressed: () {
                    if (BlocProvider.of<AuthBloc>(context).state
                        is Unauthenticated) {
                      showCustomDialog(context);
                    } else {
                      addProductConfirm(product);
                    }
                  },
                ),
              ),
            )
          else
            PositionedDirectional(
              bottom: 0,
              end: 16,
              child: Container(
                height: 30.0,
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.primaryColor),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        product.quantity--;
                        if (product.quantity < 1) {
                          cartProducts.removeWhere(
                              (element) => element.id == product.id);
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
                        cartProducts
                            .removeWhere((element) => element.id == product.id);
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

  bool _isListEmpty() {
    switch (widget._searchType) {
      case "store":
        return _vendors.isEmpty;
      case "product":
        return _products.isEmpty;
      default:
        return false;
    }
  }
}
