import 'package:delivoo/HomeOrderAccount/ProductRepository/product_repository.dart';
import 'package:delivoo/JsonFiles/Products/product_data.dart';
import 'package:delivoo/JsonFiles/base_list_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'items_event.dart';
import 'items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final int vendorId;
  final int categoryId;
  ProductRepository _repository = ProductRepository();

  ItemsBloc(this.vendorId, this.categoryId) : super(LoadingState());

  @override
  Stream<ItemsState> mapEventToState(ItemsEvent event) async* {
    if (event is FetchItemsEvent) {
      yield* _mapFetchItemsToState();
    }
  }

  Stream<ItemsState> _mapFetchItemsToState() async* {
    yield LoadingState();
    try {
      BaseListResponse<ProductData> listProduct =
          await _repository.listOfProducts(vendorId, categoryId);
      yield SuccessItemsState(listProduct.data);
    } catch (e) {
      yield FailureState(e);
    }
  }
}
