import 'package:delivoo/HomeOrderAccount/ProductRepository/product_repository.dart';
import 'package:delivoo/JsonFiles/Ratings/ratings_list.dart';
import 'package:delivoo/ReviewPage/ReviewsBloc/reviews_event.dart';
import 'package:delivoo/ReviewPage/ReviewsBloc/reviews_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewsBloc extends Bloc<ReviewsEvent, ReviewsState> {
  final int id;

  ProductRepository _repository = ProductRepository();

  ReviewsBloc(this.id) : super(LoadingReviewsState());

  @override
  Stream<ReviewsState> mapEventToState(ReviewsEvent event) async* {
    if (event is GetReviewsEvent) {
      yield* _mapGetReviewsToState();
    }
  }

  Stream<ReviewsState> _mapGetReviewsToState() async* {
    yield LoadingReviewsState();
    try {
      RatingsList ratingsList = await _repository.getVendorReviews(id);
      yield SuccessReviewsState(ratingsList);
    } catch (e) {
      yield FailureReviewsState(e);
    }
  }
}
