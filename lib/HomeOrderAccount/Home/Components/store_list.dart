import 'package:delivoo/Components/cached_image.dart';
import 'package:delivoo/Components/show_toast.dart';
import 'package:delivoo/Items/items_page.dart';
import 'package:delivoo/JsonFiles/Vendors/vendor_data.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/UtilityFunctions/app_settings.dart';
import 'package:delivoo/UtilityFunctions/helper.dart';
import 'package:flutter/material.dart';

class StoreList extends StatelessWidget {
  final List<Vendor> vendors;

  StoreList(this.vendors);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 20),
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        return StoreCard(vendors[index]);
      },
    );
  }
}

class StoreCard extends StatelessWidget {
  final Vendor vendor;

  StoreCard(this.vendor);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemsPage(vendor),
            ),
          );
        } catch (e) {
          showToast(AppLocalizations.of(context).networkError);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, top: 20, right: 20.0),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedImage(
                vendor.getImage(),
                height: 92,
                width: 92,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(vendor.name,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                          color: Theme.of(context).secondaryHeaderColor)),
                  SizedBox(height: 8.0),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: kIconColor,
                        size: 10,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                          Helper.formatDistanceString((vendor?.distance ?? 0),
                              AppSettings.distanceMetric),
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: kLightTextColor, fontSize: 10.0)),
                      Text('| ',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: kMainColor, fontSize: 10.0)),
                      Text(vendor.address.split(',').first ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: kLightTextColor, fontSize: 10.0)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        color: kIconColor,
                        size: 10,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                          AppLocalizations.of(context)
                                  .getTranslationOf('minimum') +
                              ' ${vendor.getMeta()?.time ?? 30} ' +
                              AppLocalizations.of(context)
                                  .getTranslationOf('mins'),
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: kLightTextColor, fontSize: 10.0)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Icon(Icons.star, color: kMainColor, size: 10),
                      SizedBox(width: 10.0),
                      Text(vendor.ratings.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.caption.copyWith(
                              color: kMainColor,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold)),
                      SizedBox(width: 8.0),
                      Text(
                          '${vendor.ratingsCount} ' +
                              AppLocalizations.of(context)
                                  .getTranslationOf('reviews'),
                          style: Theme.of(context).textTheme.overline),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
