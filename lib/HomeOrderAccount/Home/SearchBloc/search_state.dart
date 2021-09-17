import 'package:delivoo/JsonFiles/base_list_response.dart';
import 'package:equatable/equatable.dart';

class SearchState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class InitialSearch extends SearchState {}

class LoadingSearch extends SearchState {}

class LoadedSearch<T> extends SearchState {
  final BaseListResponse<T> searchResult;
  LoadedSearch(this.searchResult);
  @override
  List<Object> get props => [searchResult];
}

class FailureSearch extends SearchState {
  final e;

  FailureSearch(this.e);

  @override
  List<Object> get props => [e];
}
