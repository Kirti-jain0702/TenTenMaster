import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delivoo/JsonFiles/custom_location.dart';
import 'package:delivoo/Maps/map_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'order_map_event.dart';
import 'order_map_state.dart';

class OrderMapBloc extends Bloc<OrderMapEvent, OrderMapState> {
  final LatLng _pickupLatLng;
  final LatLng _dropLatLng;
  final String _instruction;
  int delId;

  OrderMapBloc(
    this._pickupLatLng,
    this._dropLatLng,
    this._instruction,
    this.delId,
  ) : super(OrderMapState(
          Markers(
              getPickupMarker(_pickupLatLng), getDropMarker(_dropLatLng), null),
          {},
          _pickupLatLng,
          _dropLatLng,
          _instruction,
          null,
        ));

  MapRepository _mapRepository = MapRepository();
  StreamSubscription _subscription;

  @override
  Stream<OrderMapState> mapEventToState(OrderMapEvent event) async* {
    if (event is LoadPageEvent) {
      yield* _mapLoadingPageEventToState();
    } else if (event is AddDeliveryIdEvent) {
      if (delId != event.deliveryId) {
        delId = event.deliveryId;
        _mapAddDeliveryMarkerToState(event.deliveryId);
      }
    } else if (event is UpdateDeliveryMarkerEvent) {
      yield* _mapUpdateDeliveryMarkerToState(event.deliveryMarker);
    }
  }

  Stream<OrderMapState> _mapLoadingPageEventToState() async* {
    var sourceMarker = getPickupMarker(_pickupLatLng);
    var destMarker = getDropMarker(_dropLatLng);
    Markers markers = Markers(sourceMarker, destMarker, null);
    Set<Polyline> polylines = Set();
    polylines.add(await _getPolyLine());
    yield OrderMapState(
        markers, polylines, _pickupLatLng, _dropLatLng, _instruction, null);
    _mapAddDeliveryMarkerToState(delId);
  }

  static Marker getDropMarker(LatLng latLng) =>
      getMarker(latLng, 'drop', BitmapDescriptor.defaultMarkerWithHue(90));

  static Marker getPickupMarker(LatLng latLng) =>
      getMarker(latLng, 'pickup', BitmapDescriptor.defaultMarker);

  _mapAddDeliveryMarkerToState(int deliveryId) {
    if (deliveryId == null) return;
    _subscription?.cancel();
    _subscription =
        _mapRepository.getDeliveryLatLng(deliveryId).listen((event) async {
      var descriptor = await getMarkerPic();
      if (event.snapshot.value != null) {
        CustomLocation location = CustomLocation.fromJson(event.snapshot.value);
        var deliveryMarker = getMarker(
            LatLng(location.latitude, location.longitude),
            'delivery',
            descriptor);
        add(UpdateDeliveryMarkerEvent(deliveryMarker));
      }
    });
  }

  Stream<OrderMapState> _mapUpdateDeliveryMarkerToState(
      Marker delivery) async* {
    var markers = Markers.updateDelivery(state.markers, delivery);
    yield OrderMapState.updateMarkers(state, markers);
  }

  Future<BitmapDescriptor> getMarkerPic() {
    return BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/deliveryman.png');
  }

  static Marker getMarker(
      LatLng latLng, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: latLng);
    return marker;
  }

  Future<Polyline> _getPolyLine() async {
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
        width: 3,
        polylineId: id,
        points: await _mapRepository.getPolylineCoordinates(
            _pickupLatLng, _dropLatLng));
    return polyline;
  }
}
