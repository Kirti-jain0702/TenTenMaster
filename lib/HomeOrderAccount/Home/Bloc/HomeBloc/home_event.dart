import 'package:delivoo/Maps/location_selected.dart';
import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class GetCurrentAddressEvent extends HomeEvent {
  final bool loadSaved;
  final LocationSelected selectedLocation;

  GetCurrentAddressEvent(this.loadSaved, {this.selectedLocation});

  @override
  List<Object> get props => [loadSaved, selectedLocation];
}

class NewValueSelectedEvent extends HomeEvent {
  final String newValue;

  NewValueSelectedEvent(this.newValue);

  @override
  List<Object> get props => [newValue];
}

class NoValueSelectedEvent extends HomeEvent {}

class RequestLocationServicesEvent extends HomeEvent {}
