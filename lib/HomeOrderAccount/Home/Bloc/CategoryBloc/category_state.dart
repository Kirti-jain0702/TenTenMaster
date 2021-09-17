import 'package:delivoo/JsonFiles/Categories/category_data.dart';
import 'package:equatable/equatable.dart';

abstract class CategoryState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadingCategoryState extends CategoryState {}

class SuccessCategoryState extends CategoryState {
  final List<CategoryData> listOfCategoryData;

  SuccessCategoryState(this.listOfCategoryData);
  @override
  List<Object> get props => [listOfCategoryData];
}

class FailureCategoryState extends CategoryState {
  final Exception e;
  FailureCategoryState(this.e);

  @override
  List<Object> get props => [e];
}
