import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ReviewsBloc/reviews_bloc.dart';
import 'ReviewsBloc/reviews_event.dart';
import 'ReviewsBloc/reviews_state.dart';

class ReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int id = ModalRoute.of(context).settings.arguments;
    return BlocProvider<ReviewsBloc>(
        create: (context) => ReviewsBloc(id)..add(GetReviewsEvent()),
        child: ReviewBody());
  }
}

class ReviewBody extends StatefulWidget {
  @override
  _ReviewBodyState createState() => _ReviewBodyState();
}

class _ReviewBodyState extends State<ReviewBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewsBloc, ReviewsState>(
      builder: (context, state) {
        if (state is SuccessReviewsState) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(100.0),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: AppBar(
                  title: state.ratingsList.data.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(state.ratingsList.data.first.vendor.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor)),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: kMainColor,
                                  size: 10,
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                    state.ratingsList.data.first.vendor.ratings
                                        .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .overline
                                        .copyWith(color: kMainColor)),
                                SizedBox(width: 8.0),
                                Text(
                                    state.ratingsList.data.first.vendor
                                        .ratingsCount
                                        .toString(),
                                    style:
                                        Theme.of(context).textTheme.overline),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 8.0,
                              color: Theme.of(context).cardColor,
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                ),
              ),
            ),
            body: state.ratingsList.data.isNotEmpty
                ? ListView.builder(
                    itemCount: state.ratingsList.data.length,
                    itemBuilder: (context, index) {
                      var rating = state.ratingsList.data[index];
                      var date = DateTime.parse(rating.createdAt);
                      var month = convertToString(date.month);
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rating.user.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(fontSize: 15.0),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: kMainColor,
                                    size: 13,
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(rating.rating.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(color: kMainColor)),
                                  Spacer(),
                                  Text(
                                    '${date.day} $month, ${date.year}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                            fontSize: 11.7,
                                            color: Color(0xffd7d7d7)),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              rating.review,
                              textAlign: TextAlign.justify,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(color: Color(0xff6a6c74)),
                            )
                          ],
                        ),
                      );
                    })
                : Center(
                    child: Text(AppLocalizations.of(context)
                        .getTranslationOf('no_reviews_yet'))),
          );
        } else if (state is FailureReviewsState) {
          return Scaffold(
              body: Center(
                  child: Text(AppLocalizations.of(context).networkError)));
        } else {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}

String convertToString(int month) {
  switch (month) {
    case 1:
      return 'January';
      break;
    case 2:
      return 'February';
      break;
    case 3:
      return 'March';
      break;
    case 4:
      return 'April';
      break;
    case 5:
      return 'May';
      break;
    case 6:
      return 'June';
      break;
    case 7:
      return 'July';
      break;
    case 8:
      return 'August';
      break;
    case 9:
      return 'September';
      break;
    case 10:
      return 'October';
      break;
    case 11:
      return 'November';
      break;
    case 12:
      return 'December';
      break;
    default:
      return month.toString();
  }
}
