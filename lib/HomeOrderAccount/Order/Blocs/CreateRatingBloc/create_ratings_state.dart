part of 'create_ratings_bloc.dart';

abstract class CreateRatingsState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class CreateRatingsInitial extends CreateRatingsState {}

class CreateRatingsInProgress extends CreateRatingsState {}

class CreateRatingsSuccess extends CreateRatingsState {}

class CreateRatingsFailure extends CreateRatingsState {
  final e;

  CreateRatingsFailure(this.e);

  @override
  List<Object> get props => [e];
}
