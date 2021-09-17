import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Components/cached_image.dart';
import 'package:delivoo/Components/entry_field.dart';
import 'package:delivoo/Components/show_toast.dart';
import 'package:delivoo/HomeOrderAccount/Order/Blocs/CreateRatingBloc/create_ratings_bloc.dart';
import 'package:delivoo/JsonFiles/Vendors/vendor_data.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateNowPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Vendor vendor = ModalRoute.of(context).settings.arguments;
    return BlocProvider<CreateRatingsBloc>(
      create: (context) => CreateRatingsBloc(vendor?.id),
      child: RateNowBody(vendor),
    );
  }
}

class RateNowBody extends StatefulWidget {
  final Vendor vendor;

  RateNowBody(this.vendor);

  @override
  _RateNowBodyState createState() => _RateNowBodyState();
}

class _RateNowBodyState extends State<RateNowBody> {
  TextEditingController _controller = TextEditingController();
  double rating;
  bool isLoaderShowing = false;

  CreateRatingsBloc _createRatingsBloc;

  @override
  void initState() {
    super.initState();
    _createRatingsBloc = BlocProvider.of<CreateRatingsBloc>(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateRatingsBloc, CreateRatingsState>(
      listener: (context, state) async {
        if (state is CreateRatingsInProgress) {
          showLoader();
        } else {
          dismissLoader();
        }
        if (state is CreateRatingsSuccess) {
          showToast(
              AppLocalizations.of(context).getTranslationOf('review_posted'));
          Navigator.pop(context);
        } else if (state is CreateRatingsFailure) {
          showToast(AppLocalizations.of(context)
              .getTranslationOf('review_not_posted'));
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: AppBar(
              centerTitle: true,
              title: Text(AppLocalizations.of(context).rate,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: kMainTextColor)),
            ),
          ),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context).how,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                  Text(
                    AppLocalizations.of(context).withR,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: CachedImage(
                      widget.vendor.mediaUrls != null &&
                              widget.vendor.mediaUrls.images != null
                          ? widget.vendor.mediaUrls?.images?.first?.defaultImage
                          : widget.vendor.categories?.first?.mediaUrls?.images
                              ?.first?.defaultImage,
                    ),
                  ),
                  Text(
                    widget.vendor.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(fontWeight: FontWeight.w400, fontSize: 15.0),
                  ),
                  SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 44.0),
                    child: Center(
                      child: RatingBar.builder(
                        minRating: 1,
                        itemCount: 5,
                        glowColor: kTransparentColor,
                        unratedColor: Color(0xffe6e6e6),
                        onRatingUpdate: (value) {
                          rating = value;
                        },
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: kMainColor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context).addReview,
                        style: Theme.of(context).textTheme.caption.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 10.0,
                            color: Color(0xff838383),
                            letterSpacing: 0.5),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36.0),
                    child: EntryField(
                      controller: _controller,
                      label: AppLocalizations.of(context).writeReview,
                    ),
                  ),
                  SizedBox(
                    height: 300,
                  )
                ],
              ),
            ),
            BottomBar(
              onTap: () {
                if (_controller.text.trim().length < 10 ||
                    _controller.text.trim().length > 140) {
                  showToast(AppLocalizations.of(context)
                      .getTranslationOf("invalid_length_message"));
                } else {
                  _createRatingsBloc
                      .add(PostRatingsEvent(rating, _controller.text));
                }
              },
              text: AppLocalizations.of(context).feedback,
            ),
          ],
        ),
      ),
    );
  }

  showLoader() {
    if (!isLoaderShowing) {
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(kMainColor),
          ));
        },
      );
      isLoaderShowing = true;
    }
  }

  dismissLoader() {
    if (isLoaderShowing) {
      Navigator.of(context).pop();
      isLoaderShowing = false;
    }
  }
}
