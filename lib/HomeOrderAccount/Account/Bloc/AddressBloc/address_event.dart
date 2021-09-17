import 'package:delivoo/JsonFiles/Address/getaddress_json.dart';
import 'package:equatable/equatable.dart';

abstract class AddressEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class FetchAddressesEvent extends AddressEvent {}

class ShowAddressesEvent extends AddressEvent {
  final GetAddress address;

  ShowAddressesEvent(this.address);

  @override
  List<Object> get props => [address];
}

class GetSelectedAddressEvent extends AddressEvent {
  final GetAddress address;

  GetSelectedAddressEvent({this.address});

  @override
  List<Object> get props => [address];
}

class ClearAddressEvent extends AddressEvent {}

class DeleteAddressEvent extends AddressEvent {
  final int addressId;

  DeleteAddressEvent(this.addressId);

  @override
  List<Object> get props => [addressId];
}
