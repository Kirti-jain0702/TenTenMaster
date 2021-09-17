import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderMapEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadPageEvent extends OrderMapEvent {}

class AddDeliveryIdEvent extends OrderMapEvent {
  final int deliveryId;

  AddDeliveryIdEvent(this.deliveryId);

  @override
  List<Object> get props => [deliveryId];
}

class UpdateDeliveryMarkerEvent extends OrderMapEvent {
  final Marker deliveryMarker;

  UpdateDeliveryMarkerEvent(this.deliveryMarker);

  @override
  List<Object> get props => [deliveryMarker];
}
