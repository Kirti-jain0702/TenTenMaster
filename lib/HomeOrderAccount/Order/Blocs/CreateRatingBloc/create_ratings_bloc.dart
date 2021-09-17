import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delivoo/HomeOrderAccount/ProductRepository/product_repository.dart';
import 'package:delivoo/JsonFiles/Ratings/post_rating.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'create_ratings_event.dart';
part 'create_ratings_state.dart';

class CreateRatingsBloc extends Bloc<CreateRatingsEvent, CreateRatingsState> {
  final int vendorId;

  CreateRatingsBloc(this.vendorId) : super(CreateRatingsInitial());

  ProductRepository _repository = ProductRepository();

  @override
  Stream<CreateRatingsState> mapEventToState(CreateRatingsEvent event) async* {
    if (event is PostRatingsEvent) {
      yield* _mapPostRatingToState(event);
    }
  }

  Stream<CreateRatingsState> _mapPostRatingToState(
      PostRatingsEvent event) async* {
    yield CreateRatingsInProgress();
    try {
      PostRating postRating = PostRating(event.rating, event.review);
      await _repository.postReview(vendorId, postRating);
      var prefs = await SharedPreferences.getInstance();
      await prefs.setBool("reviewed_vendor_$vendorId", true);
      yield CreateRatingsSuccess();
    } catch (e) {
      yield CreateRatingsFailure(e);
    }
  }
}
