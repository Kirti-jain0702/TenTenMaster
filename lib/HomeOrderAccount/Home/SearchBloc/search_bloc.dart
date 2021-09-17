import 'package:bloc/bloc.dart';
import 'package:delivoo/HomeOrderAccount/Home/SearchBloc/search_event.dart';
import 'package:delivoo/HomeOrderAccount/Home/SearchBloc/search_state.dart';
import 'package:delivoo/HomeOrderAccount/HomeRepository/home_repository.dart';
import 'package:delivoo/JsonFiles/Products/product_data.dart';
import 'package:delivoo/JsonFiles/Vendors/vendor_data.dart';
import 'package:delivoo/JsonFiles/base_list_response.dart';
import 'package:delivoo/Maps/map_repository.dart';
import 'package:geolocator/geolocator.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  HomeRepository _homeRepository = HomeRepository();
  MapRepository _mapRepository = MapRepository();

  SearchBloc() : super(InitialSearch());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchVendorsEvent) {
      yield* _mapSearchVendorsToState(
          event.vendorText, event.catId, event.pageNum);
    } else if (event is SearchProductsEvent) {
      yield* _mapSearchProductsToState(event);
    } else if (event is SearchClearEvent) {
      yield InitialSearch();
    }
  }

  Stream<SearchState> _mapSearchVendorsToState(
      String vendorText, int catId, int page) async* {
    yield LoadingSearch();
    try {
      Position position = await getLatLng();
      BaseListResponse<Vendor> searchList = await _homeRepository.searchVendors(
          vendorText, catId, page, position);
      yield LoadedSearch(searchList);
    } catch (e) {
      yield FailureSearch(e);
    }
  }

  Stream<SearchState> _mapSearchProductsToState(
      SearchProductsEvent event) async* {
    yield LoadingSearch();
    try {
      BaseListResponse<ProductData> searchList = await _homeRepository
          .searchProducts(event.vendorId, event.productText, event.pageNum);
      yield LoadedSearch(searchList);
    } catch (e) {
      yield FailureSearch(e);
    }
  }

  Future<Position> getLatLng() async {
    return await _mapRepository.getCurrentLocation();
  }
}
