import 'dart:convert';

import 'package:delivoo/AppConfig/app_config.dart';
import 'package:delivoo/Maps/location_selected.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapRepository {
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: AppConfig.apiKey);
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  Future<Position> getCurrentLocation() async {

    loc.Location location = new loc.Location();
    bool _serviceEnabled;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print('Location Denied once');
      }
    }

    print("#################-----  Location  enabled::  $_serviceEnabled  ------#################"); // true

    Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return position;
  }

  Future<LocationSelected> getSelectedLocation() async {
    var prefs = await SharedPreferences.getInstance();
    Map savedLocationMap = await prefs.containsKey("current_location")
        ? (json.decode(prefs.getString("current_location")))
        : null;
    LocationSelected locationSelected = savedLocationMap != null
        ? LocationSelected.fromJson(savedLocationMap)
        : null;
    if (locationSelected == null) {
      Position position = await getCurrentLocation();
      LatLng latLng = LatLng(position.latitude, position.longitude);
      Placemark place = await getAddressFromLatLng(latLng);
      String currentAddress = '${place.subLocality}';
      if (place.subLocality == null || place.subLocality == '')
        currentAddress = '${place.postalCode}, ${place.locality}';
      locationSelected =
          LocationSelected(currentAddress, latLng.latitude, latLng.longitude);
      await saveLocation(locationSelected);
    }
    return locationSelected;
  }

  Future<String> loadSilverMap() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('map_style')) {
      return prefs.getString('map_style');
    } else {
      String mapStyle = await rootBundle.loadString('images/map_style.txt');
      prefs.setString('map_style', mapStyle);
      return mapStyle;
    }
  }

  Future<Placemark> getAddressFromLatLng(LatLng latLng) async {
    List<Placemark> p = await geolocator.placemarkFromCoordinates(
        latLng.latitude, latLng.longitude);
    Placemark place = p[0];
    return place;
  }

  Future<PlaceDetails> getPlaceDetails(String placeId) async {
    PlacesDetailsResponse response = await _places.getDetailsByPlaceId(placeId);
    print("getPlaceDetails: ${response.status}");
    print("getPlaceDetails: ${response.errorMessage}");
    return response.result;
  }

  LatLng getLatLng(PlaceDetails placeDetails) {
    LatLng latLng = LatLng(
        placeDetails.geometry.location.lat, placeDetails.geometry.location.lng);
    return latLng;
  }

  Stream<Event> getDeliveryLatLng(int deliveryId) {
    return _databaseReference.child('deliveries/$deliveryId/location').onValue;
  }

  Future<List<LatLng>> getPolylineCoordinates(
      LatLng pickupLatLng, LatLng dropLatLng) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppConfig.apiKey,
      PointLatLng(pickupLatLng.latitude, pickupLatLng.longitude),
      PointLatLng(dropLatLng.latitude, dropLatLng.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    return polylineCoordinates;
  }

  Future<bool> saveLocation(LocationSelected locationSelected) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setString("current_location", json.encode(locationSelected));
  }
}
