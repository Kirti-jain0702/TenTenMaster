import 'package:equatable/equatable.dart';
import 'package:google_maps_webservice/places.dart';

abstract class CustomDeliveryEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class PickupSelectedEvent extends CustomDeliveryEvent {
  final Prediction pickupPrediction;

  PickupSelectedEvent(this.pickupPrediction);

  @override
  List<Object> get props => [pickupPrediction];
}

class DropSelectedEvent extends CustomDeliveryEvent {
  final Prediction dropPrediction;

  DropSelectedEvent(this.dropPrediction);

  @override
  List<Object> get props => [dropPrediction];
}

class FetchDeliveryFeeEvent extends CustomDeliveryEvent {}

class ValuesSelectedEvent extends CustomDeliveryEvent {
  final List<String> valuesSelected;

  ValuesSelectedEvent(this.valuesSelected);

  @override
  List<Object> get props => [valuesSelected];
}

class ValuesShowEvent extends CustomDeliveryEvent {}

class SubmittedEvent extends CustomDeliveryEvent {
  final String instruction;
  final String sourceContactName;
  final String sourceContactNumber;
  final String destinationContactName;
  final String destinationContactNumber;

  SubmittedEvent(
      this.instruction,
      this.sourceContactName,
      this.sourceContactNumber,
      this.destinationContactName,
      this.destinationContactNumber);

  @override
  List<Object> get props => [
        instruction,
        sourceContactName,
        sourceContactNumber,
        destinationContactName,
        destinationContactNumber,
      ];
}
