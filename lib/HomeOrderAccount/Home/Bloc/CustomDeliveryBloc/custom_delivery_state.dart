import 'package:delivoo/JsonFiles/CustomDelivery/delivery_fee.dart';
import 'package:delivoo/JsonFiles/Order/Get/order_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomDeliveryState extends Equatable {
  final String pickupAddress;
  final LatLng pickupLatLng;
  final String dropAddress;
  final LatLng dropLatLng;
  final List<String> selectedValues;
  final String instruction;
  final bool isSelected;
  final bool isEnabled;
  final bool goToNextPage;
  final OrderData orderData;
  final DeliveryFee deliveryFee;

  CustomDeliveryState({
    @required this.pickupAddress,
    @required this.pickupLatLng,
    @required this.dropAddress,
    @required this.dropLatLng,
    @required this.selectedValues,
    @required this.isSelected,
    @required this.isEnabled,
    @required this.goToNextPage,
    @required this.instruction,
    this.orderData,
    this.deliveryFee,
  });

  @override
  List<Object> get props => [
        selectedValues,
        isSelected,
        isEnabled,
        pickupAddress,
        pickupLatLng,
        dropAddress,
        dropLatLng,
        instruction,
        goToNextPage,
        orderData,
      ];

  @override
  bool get stringify => true;
}

class CustomDeliveryErrorState extends CustomDeliveryState {}
