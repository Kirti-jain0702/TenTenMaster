import 'package:delivoo/HomeOrderAccount/Home/Bloc/StoresBloc/stores_event.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/StoresBloc/stores_state.dart';
import 'package:delivoo/HomeOrderAccount/ProductRepository/product_repository.dart';
import 'package:delivoo/JsonFiles/Vendors/vendor_data.dart';
import 'package:delivoo/JsonFiles/base_list_response.dart';
import 'package:delivoo/Maps/location_selected.dart';
import 'package:delivoo/Maps/map_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final int id;

  ProductRepository _repository = ProductRepository();
  MapRepository _mapRepository = MapRepository();

  StoreBloc(this.id) : super(null);

  StoreState get initialState => LoadingState();

  @override
  Stream<StoreState> mapEventToState(StoreEvent event) async* {
    if (event is FetchStoreEvent) {
      yield* _mapFetchStoreToState(event.page);
    }
  }

  Stream<StoreState> _mapFetchStoreToState(int page) async* {
    yield LoadingState();
    BaseListResponse<Vendor> listVendors;
    try {
      LocationSelected locationSelected =
          await _mapRepository.getSelectedLocation();
      listVendors = await _repository.listOfVendors(
          id, locationSelected.latitude, locationSelected.longitude, page);
      yield SuccessStoreState(listVendors);
    } catch (e) {
      yield FailureStoresState(e);
    }
  }
}
