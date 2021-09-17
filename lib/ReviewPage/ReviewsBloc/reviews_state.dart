import 'package:delivoo/JsonFiles/Ratings/ratings_list.dart';
import 'package:equatable/equatable.dart';

class ReviewsState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadingReviewsState extends ReviewsState {}

class SuccessReviewsState extends ReviewsState {
  final RatingsList ratingsList;

  SuccessReviewsState(this.ratingsList);

  @override
  List<Object> get props => [ratingsList];
}

class FailureReviewsState extends ReviewsState {
  final e;

  FailureReviewsState(this.e);

  @override
  List<Object> get props => [e];
}
