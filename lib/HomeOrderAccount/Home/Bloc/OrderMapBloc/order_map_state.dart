import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderMapState extends Equatable {
  final Markers markers;
  final Set<Polyline> polylines;
  final LatLng pickupLatLng;
  final LatLng dropLatLng;
  final String instruction;
  final LatLng deliveryLatLng;

  OrderMapState(this.markers, this.polylines, this.pickupLatLng,
      this.dropLatLng, this.instruction, this.deliveryLatLng);

  factory OrderMapState.updateMarkers(OrderMapState state, Markers markers) =>
      OrderMapState(
        markers,
        state.polylines,
        state.pickupLatLng,
        state.dropLatLng,
        state.instruction,
        state.deliveryLatLng,
      );

  @override
  List<Object> get props => [
        markers,
        polylines,
        pickupLatLng,
        dropLatLng,
        instruction,
        deliveryLatLng,
      ];

  @override
  bool get stringify => true;
}

class Markers extends Equatable {
  final Marker source;
  final Marker destination;
  final Marker delivery;

  Markers(this.source, this.destination, this.delivery);

  factory Markers.updateDelivery(Markers source, Marker delivery) =>
      Markers(source.source, source.destination, delivery);

  @override
  List<Object> get props => [source, destination, delivery];

  @override
  bool get stringify => true;

  Set<Marker> toSet() {
    var set = {source, destination};
    if (delivery != null) {
      set.add(delivery);
    }
    return set;
  }
}
