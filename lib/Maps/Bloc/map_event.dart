import 'package:delivoo/JsonFiles/Address/getaddress_json.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

abstract class MapEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class UpdateCameraPositionEvent extends MapEvent {
  final CameraPosition position;
  final bool reverseGeocode;

  UpdateCameraPositionEvent(this.position, this.reverseGeocode);

  @override
  List<Object> get props => [position, reverseGeocode];
}

class UpdateAddressEvent extends MapEvent {
  final CameraPosition position;

  UpdateAddressEvent(this.position);

  @override
  List<Object> get props => [position];
}

class LocationSelectedEvent extends MapEvent {
  final Prediction prediction;

  LocationSelectedEvent(this.prediction);

  @override
  List<Object> get props => [prediction];
}

class MarkerMovedEvent extends MapEvent {}

class FetchCurrentLocation extends MapEvent {}

class FetchLocation extends MapEvent {
  final GetAddress address;
  final bool showPrevious;

  FetchLocation(this.address, this.showPrevious);

  @override
  List<Object> get props => [address, showPrevious];
}

class ShowCardEvent extends MapEvent {}

class LocationSelectionOutEvent extends MapEvent {
  final bool fullAddress;
  final double longitude;
  final double latitude;

  LocationSelectionOutEvent(this.fullAddress, this.longitude, this.latitude);

  @override
  List<Object> get props => [fullAddress, longitude, latitude];
}

class AddressSubmittedEvent extends MapEvent {
  final int addressId;
  final String title;
  final String formattedAddress;
  final double longitude;
  final double latitude;

  AddressSubmittedEvent(this.addressId, this.title, this.formattedAddress,
      this.longitude, this.latitude);

  @override
  List<Object> get props => [title, formattedAddress, longitude, latitude];
}
