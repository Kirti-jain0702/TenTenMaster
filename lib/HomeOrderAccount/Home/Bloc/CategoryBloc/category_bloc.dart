import 'package:delivoo/HomeOrderAccount/ProductRepository/product_repository.dart';
import 'package:delivoo/JsonFiles/Categories/list_categories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  ProductRepository _repository = ProductRepository();

  CategoryBloc() : super(LoadingCategoryState());

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is FetchCategoryEvent) {
      yield* _mapFetchCategoryToState();
    }
  }

  Stream<CategoryState> _mapFetchCategoryToState() async* {
    yield LoadingCategoryState();
    try {
      ListCategories listCategories = await _repository.listOfCategories();
      yield SuccessCategoryState(listCategories.listOfData);
    } catch (e) {
      yield FailureCategoryState(e);
    }
  }
}
