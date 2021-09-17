import 'package:delivoo/Components/custom_appbar.dart';
import 'package:delivoo/Components/error_final_widget.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/StoresBloc/stores_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/StoresBloc/stores_event.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/StoresBloc/stores_state.dart';
import 'package:delivoo/HomeOrderAccount/Home/Components/store_list.dart';
import 'package:delivoo/HomeOrderAccount/Home/LoadingPlaceHolders/store_place_holder.dart';
import 'package:delivoo/HomeOrderAccount/Home/UI/search_page.dart';
import 'package:delivoo/JsonFiles/Vendors/vendor_data.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoresPage extends StatelessWidget {
  final String pageTitle;
  final int id;

  StoresPage(this.pageTitle, this.id);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StoreBloc>(
        create: (BuildContext context) =>
            StoreBloc(id)..add(FetchStoreEvent(1)),
        child: StoresBody(id, pageTitle));
  }
}

class StoresBody extends StatefulWidget {
  final int catId;
  final String pageTitle;

  StoresBody(this.catId, this.pageTitle);

  @override
  _StoresBodyState createState() => _StoresBodyState();
}

class _StoresBodyState extends State<StoresBody> {
  StoreBloc _storeBloc;
  List<Vendor> _vendors = [];
  int _page = 1;
  bool _doneAll = false, _isLoading = false;

  @override
  void initState() {
    super.initState();
    _storeBloc = BlocProvider.of<StoreBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(114.0),
        child: CustomAppBar(
          titleWidget: Text(
            widget.pageTitle,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          readOnly: true,
          hint: AppLocalizations.of(context).getTranslationOf("search_stores"),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SearchPage.searchStores(categoryId: widget.catId))),
        ),
      ),
      body: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          _isLoading = state is LoadingState;
          if (state is SuccessStoreState) {
            if (state.listOfVendorData.meta.current_page == 1) {
              _vendors = state.listOfVendorData.data;
            } else {
              _vendors.addAll(state.listOfVendorData.data);
            }
            _page = state.listOfVendorData.meta.current_page;
            _doneAll = state.listOfVendorData.meta.current_page ==
                state.listOfVendorData.meta.last_page;
          }
          if (_vendors.isNotEmpty)
            return ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 20.0, top: 20.0),
                  child: Text(
                    '${_vendors.length} ' +
                        AppLocalizations.of(context).storeFound,
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
                    itemCount: _vendors.length,
                    itemBuilder: (context, index) {
                      if (!_doneAll &&
                          !_isLoading &&
                          index == _vendors.length - 1) {
                        _storeBloc.add(FetchStoreEvent(_page + 1));
                      }
                      return StoreCard(_vendors[index]);
                    }),
              ],
            );
          else if (state is SuccessStoreState)
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ErrorFinalWidget.errorWithRetry(
                  context,
                  AppLocalizations.of(context)
                      .getTranslationOf("empty_results"),
                  AppLocalizations.of(context).getTranslationOf("okay"),
                  () => Navigator.pop(context)),
            );
          else
            return StorePlaceHolder();
        },
      ),
    );
  }
}
