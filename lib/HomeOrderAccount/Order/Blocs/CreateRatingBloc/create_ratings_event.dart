part of 'create_ratings_bloc.dart';

abstract class CreateRatingsEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class PostRatingsEvent extends CreateRatingsEvent {
  final double rating;
  final String review;

  PostRatingsEvent(this.rating, this.review);

  @override
  List<Object> get props => [rating, review];
}
