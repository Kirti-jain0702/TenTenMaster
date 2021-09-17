import 'package:bloc/bloc.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/HomeBloc/home_event.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/HomeBloc/home_state.dart';
import 'package:delivoo/Maps/location_selected.dart';
import 'package:delivoo/Maps/map_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  MapRepository _mapRepository = MapRepository();

  HomeBloc()
      : super(HomeState(
            ['locating_loading', 'open_map'], 'locating_loading', false));

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    print("event is: ${event.runtimeType}");
    if (event is GetCurrentAddressEvent) {
      yield* _mapGetCurrentAddressToState(
          event.selectedLocation, event.loadSaved);
    } else if (event is NewValueSelectedEvent) {
      yield* _mapNewValueSelectedToState(event.newValue);
    } else if (event is NoValueSelectedEvent) {
      yield _mapNoValueSelectedToState();
    }
    // else if (event is RequestLocationServicesEvent) {
    //   _mapRepository.locationServicesEnableRequest();
    // }
  }

  Stream<HomeState> _mapGetCurrentAddressToState(
      LocationSelected selectedValue, bool loadSaved) async* {
    // provide custom LatLng and uncomment following for testing
    // await _mapRepository
    //     .saveLocation(LocationSelected("custom", 28.1899851, 76.6165783));
    List<String> listOfAddresses = [];
    if (selectedValue != null) {
      listOfAddresses.add(selectedValue.title);
      await _mapRepository.saveLocation(selectedValue);
    } else {
      if (loadSaved) {
        LocationSelected locationSelected =
            await _mapRepository.getSelectedLocation();
        listOfAddresses.add(locationSelected.title);
      } else {
        String currentAddress = await getAddressFromGeolocator();
        listOfAddresses.add(currentAddress);
      }
    }
    listOfAddresses.add('open_map');
    yield HomeState(listOfAddresses, listOfAddresses[0], false);
  }

  Future<String> getAddressFromGeolocator() async {
    Position position = await _mapRepository.getCurrentLocation();
    LatLng latLng = LatLng(position.latitude, position.longitude);
    Placemark place = await _mapRepository.getAddressFromLatLng(latLng);
    String currentAddress = '${place.subLocality}';
    if (place.subLocality == null || place.subLocality == '')
      currentAddress = '${place.postalCode}, ${place.locality}';
    await _mapRepository.saveLocation(
        LocationSelected(currentAddress, latLng.latitude, latLng.longitude));
    return currentAddress;
  }

  Stream<HomeState> _mapNewValueSelectedToState(
      String newValueSelected) async* {
    if (newValueSelected == 'open_map') {
      yield HomeState(state.addresses, state.selectedValue, true);
    } else {
      yield HomeState(state.addresses, newValueSelected, false);
    }
  }

  HomeState _mapNoValueSelectedToState() {
    return HomeState(state.addresses, state.selectedValue, false);
  }

  Future<Position> getLatLng() async {
    return await _mapRepository.getCurrentLocation();
  }
}
