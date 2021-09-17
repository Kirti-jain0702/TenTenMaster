import 'package:equatable/equatable.dart';

abstract class ReviewsEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class GetReviewsEvent extends ReviewsEvent {}
