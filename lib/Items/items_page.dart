import 'package:delivoo/Components/custom_appbar.dart';
import 'package:delivoo/Components/search_bar.dart';
import 'package:delivoo/HomeOrderAccount/Home/UI/search_page.dart';
import 'package:delivoo/JsonFiles/Vendors/vendor_data.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Routes/routes.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/UtilityFunctions/app_settings.dart';
import 'package:delivoo/UtilityFunctions/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../splash_screen_seconday.dart';
import 'items_tab.dart';

class ItemsPage extends StatelessWidget {
  final Vendor vendor;

  ItemsPage(this.vendor);

  @override
  Widget build(BuildContext context) {
    return ItemsBody(vendor);
  }
}

class ItemsBody extends StatefulWidget {
  final Vendor vendor;

  ItemsBody(this.vendor);

  @override
  _ItemsBodyState createState() => _ItemsBodyState();
}

class _ItemsBodyState extends State<ItemsBody> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.vendor.productCategories.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(214.0),
          child: CustomAppBar(
            titleWidget: Text(
              widget.vendor.name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: kIconColor,
                              size: 10,
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              Helper.formatDistanceString(
                                  (widget.vendor.distance ?? 0),
                                  AppSettings.distanceMetric),
                              style: Theme.of(context).textTheme.overline,
                            ),
                            Text(
                              '| ',
                              style: Theme.of(context)
                                  .textTheme
                                  .overline
                                  .copyWith(color: kMainColor),
                            ),
                            Text(
                              widget.vendor.area ?? '',
                              style: Theme.of(context).textTheme.overline,
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        InkWell(
                          onTap: () => Navigator.pushNamed(
                              context, PageRoutes.review,
                              arguments: widget.vendor.id),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: kIconColor,
                                size: 10,
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                AppLocalizations.of(context)
                                        .getTranslationOf('minimum') +
                                    ' ${widget.vendor.getMeta()?.time ?? 30} ' +
                                    AppLocalizations.of(context)
                                        .getTranslationOf('mins'),
                                style: Theme.of(context).textTheme.overline,
                              ),
                              Spacer(),
                              Icon(Icons.star, color: kMainColor, size: 10),
                              SizedBox(width: 8.0),
                              Text(
                                widget.vendor.ratings.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .overline
                                    .copyWith(color: kMainColor),
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                '${widget.vendor.ratingsCount} ' +
                                    AppLocalizations.of(context)
                                        .getTranslationOf('reviews'),
                                style: Theme.of(context).textTheme.overline,
                              ),
                              SizedBox(width: 8.0),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: kIconColor,
                                size: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 8),
                    child: CustomSearchBar(
                      hint: AppLocalizations.of(context)
                          .getTranslationOf('search_item'),
                      readOnly: true,
                      onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SearchPage.searchProducts(
                                          widget.vendor.id)))
                          .then((value) => setState(() {})),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TabBar(
                      tabs: widget.vendor.productCategories
                          .map((e) => Tab(text: e.title.toUpperCase()))
                          .toList(),
                      isScrollable: true,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 13, fontWeight: FontWeight.w600),
                      labelColor: kMainColor,
                      unselectedLabelColor: kLightTextColor,
                      indicatorPadding: EdgeInsets.symmetric(horizontal: 24.0),
                      physics: BouncingScrollPhysics(),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).cardColor,
                    thickness: 6.0,
                    height: 6.0,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: widget.vendor.productCategories.length > 0
            ? Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  children: widget.vendor.productCategories
                      .map((category) => ItemsTab(
                          widget.vendor.id, category.id, widget.vendor.name))
                      .toList(),
                  // child:
                ),
              )
            : TextOnlyScreen(AppLocalizations.of(context)
                .getTranslationOf('no_items_available')),
      ),
    );
  }
}
