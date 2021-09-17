import 'package:bloc/bloc.dart';
import 'package:delivoo/Auth/AuthRepo/auth_repository.dart';
import 'package:delivoo/HomeOrderAccount/HomeRepository/home_repository.dart';
import 'package:delivoo/JsonFiles/Address/getaddress_json.dart';
import 'package:delivoo/Maps/Bloc/map_event.dart';
import 'package:delivoo/Maps/Bloc/map_state.dart';
import 'package:delivoo/Maps/location_selected.dart';
import 'package:delivoo/Maps/map_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:rxdart/rxdart.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  HomeRepository _homeRepository = HomeRepository();
  MapRepository _mapRepository = MapRepository();
  AuthRepo _userRepository = AuthRepo();

  MapBloc()
      : super(
            MapState('', LatLng(20.5937, 78.9629), false, false, false, false));

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is UpdateCameraPositionEvent) {
      yield* _mapCameraPositionToState(event.position, event.reverseGeocode);
    } else if (event is UpdateAddressEvent) {
      yield* _mapUpdateAddressEventToState(event.position);
    } else if (event is LocationSelectedEvent) {
      yield* _mapLocationSelectedToState(event.prediction);
    } else if (event is MarkerMovedEvent) {
      yield _mapMarkerMovedToState();
    } else if (event is FetchLocation) {
      yield* _mapFetchLocationEvent(event.address, event.showPrevious);
    } else if (event is ShowCardEvent) {
      yield _mapShowCardToState();
    } else if (event is AddressSubmittedEvent) {
      yield* _mapAddressSubmittedToState(event);
    } else if (event is LocationSelectionOutEvent) {
      yield* _mapLocationSelectionOutToState(event);
    }
  }

  @override
  Stream<Transition<MapEvent, MapState>> transformEvents(
      Stream<MapEvent> events,
      TransitionFunction<MapEvent, MapState> transitionFn) {
    final nonDebounceStream =
        events.where((event) => (event is! UpdateAddressEvent));
    final debounceStream = events
        .where((event) => (event is UpdateAddressEvent))
        .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  Stream<MapState> _mapCameraPositionToState(
      CameraPosition position, bool reverseGeocode) async* {
    yield MapState(
        state.formattedAddress, position.target, false, false, false, false);
    if (reverseGeocode) add(UpdateAddressEvent(position));
  }

  Stream<MapState> _mapUpdateAddressEventToState(
      CameraPosition position) async* {
    String currentAddress = await getAddress(position.target, true);
    yield MapState(currentAddress, position.target, false, false, false, false);
  }

  Stream<MapState> _mapLocationSelectedToState(Prediction prediction) async* {
    print(prediction);
    PlaceDetails placeDetails =
        await _mapRepository.getPlaceDetails(prediction.placeId);
    print(placeDetails);
    String address = placeDetails.formattedAddress;
    LatLng latLng = _mapRepository.getLatLng(placeDetails);
    CameraPosition position = CameraPosition(target: latLng);
    yield MapState(address, position.target, true, false, false, false);
  }

  MapState _mapMarkerMovedToState() {
    return MapState(
        state.formattedAddress, state.latLng, false, false, false, false);
  }

  Stream<MapState> _mapFetchLocationEvent(
      GetAddress addressToShow, bool showPrevious) async* {
    String currentAddress;
    LatLng latLng;
    if (addressToShow != null) {
      latLng = LatLng(addressToShow.latitude, addressToShow.longitude);
      currentAddress = addressToShow.formattedAddress;
    } else if (showPrevious) {
      LocationSelected locationSelected =
          await _mapRepository.getSelectedLocation();
      latLng = LatLng(locationSelected.latitude, locationSelected.longitude);
      currentAddress = await getAddress(latLng, true);
    } else {
      Position position = await _mapRepository.getCurrentLocation();
      latLng = LatLng(position.latitude, position.longitude);
      currentAddress = await getAddress(latLng, true);
    }
    yield MapState(
      currentAddress,
      latLng,
      true,
      false,
      false,
      false,
    );
  }

  Future<String> getAddress(LatLng latLng, bool full) async {
    Placemark place = await _mapRepository.getAddressFromLatLng(latLng);
    print("Address For: ${place.toJson()}");
    String currentAddress = "";
    List<String> addressComponents = [];
    if (place.name != null && place.name.isNotEmpty)
      addressComponents.add(place.name);
    if (place.subLocality != null && place.subLocality.isNotEmpty)
      addressComponents.add(place.subLocality);
    if (place.locality != null && place.locality.isNotEmpty)
      addressComponents.add(place.locality);
    if (place.postalCode != null && place.postalCode.isNotEmpty)
      addressComponents.add(place.postalCode);
    if (place.country != null && place.country.isNotEmpty)
      addressComponents.add(place.country);
    if (addressComponents.isNotEmpty)
      currentAddress = full
          ? addressComponents.join(", ")
          : (double.tryParse(addressComponents[0]) == null
              ? addressComponents[0]
              : addressComponents[1]);
    return currentAddress;
  }

  MapState _mapShowCardToState() {
    return MapState(
        state.formattedAddress, state.latLng, false, true, false, false);
  }

  Stream<MapState> _mapAddressSubmittedToState(
      AddressSubmittedEvent event) async* {
    yield MapLoading(
        state.formattedAddress,
        state.latLng,
        state.toAnimateCamera,
        state.isCardShowing,
        state.goToLoginPage,
        state.goToHomePage);
    try {
      GetAddress address;
      if (event.addressId != null && event.addressId != -1) {
        address = await _homeRepository.updateAddress(
            event.addressId,
            event.title,
            event.formattedAddress,
            event.latitude,
            event.longitude);
      } else {
        address = await _homeRepository.addAddress(event.title,
            event.formattedAddress, event.latitude, event.longitude);
      }
      yield MapLoaded(
          address,
          state.formattedAddress,
          state.latLng,
          state.toAnimateCamera,
          state.isCardShowing,
          state.goToLoginPage,
          state.goToHomePage);
    } catch (e) {
      print(e);
      yield MapLoadedError(
          (event.addressId != null && event.addressId != -1)
              ? "err_address_update"
              : "err_address_add",
          state.formattedAddress,
          state.latLng,
          state.toAnimateCamera,
          state.isCardShowing,
          state.goToLoginPage,
          state.goToHomePage);
    }
  }

  Stream<MapState> _mapLocationSelectionOutToState(
      LocationSelectionOutEvent event) async* {
    LatLng latLng = LatLng(event.latitude, event.longitude);
    String address = await getAddress(latLng, false);
    yield MapState(address, latLng, true, false, false, true);
  }
}
