import 'package:delivoo/JsonFiles/Address/getaddress_json.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState extends Equatable {
  final String formattedAddress;
  final LatLng latLng;
  final bool toAnimateCamera;
  final bool isCardShowing;
  final bool goToLoginPage;
  final bool goToHomePage;

  MapState(this.formattedAddress, this.latLng, this.toAnimateCamera,
      this.isCardShowing, this.goToLoginPage, this.goToHomePage);

  @override
  List<Object> get props => [
        formattedAddress,
        latLng,
        toAnimateCamera,
        isCardShowing,
        goToLoginPage,
        goToHomePage
      ];

  @override
  bool get stringify => true;
}

class MapLoading extends MapState {
  MapLoading(String formattedAddress, LatLng latLng, bool toAnimateCamera,
      bool isCardShowing, bool goToLoginPage, bool goToHomePage)
      : super(formattedAddress, latLng, toAnimateCamera, isCardShowing,
            goToLoginPage, goToHomePage);
}

class MapLoaded extends MapState {
  final GetAddress address;

  MapLoaded(
      this.address,
      String formattedAddress,
      LatLng latLng,
      bool toAnimateCamera,
      bool isCardShowing,
      bool goToLoginPage,
      bool goToHomePage)
      : super(formattedAddress, latLng, toAnimateCamera, isCardShowing,
            goToLoginPage, goToHomePage);

  @override
  List<Object> get props => [
        address,
        formattedAddress,
        latLng,
        toAnimateCamera,
        isCardShowing,
        goToLoginPage,
        goToHomePage
      ];
}

class MapLoadedError extends MapState {
  final String message;

  MapLoadedError(
      this.message,
      String formattedAddress,
      LatLng latLng,
      bool toAnimateCamera,
      bool isCardShowing,
      bool goToLoginPage,
      bool goToHomePage)
      : super(formattedAddress, latLng, toAnimateCamera, isCardShowing,
            goToLoginPage, goToHomePage);

  @override
  List<Object> get props => [
        message,
        formattedAddress,
        latLng,
        toAnimateCamera,
        isCardShowing,
        goToLoginPage,
        goToHomePage
      ];
}
