import 'package:delivoo/JsonFiles/Address/getaddress_json.dart';
import 'package:equatable/equatable.dart';

class AddressState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadingAddressState extends AddressState {}

class SuccessAddressState extends AddressState {
  final List<GetAddress> addresses;

  SuccessAddressState(this.addresses);

  @override
  List<Object> get props => [addresses];
}

class GetSelectedAddressSuccessState extends AddressState {
  final GetAddress address;

  GetSelectedAddressSuccessState(this.address);

  @override
  List<Object> get props => [address];
}

class GetSelectedAddressFailureState extends AddressState {
  final e;

  GetSelectedAddressFailureState(this.e);

  @override
  List<Object> get props => [e];
}

class FailureAddressState extends AddressState {
  final e;

  FailureAddressState(this.e);

  @override
  List<Object> get props => [e];
}

class DeletingAddressState extends AddressState {}

class DeleteAddressSuccessState extends AddressState {}

class DeleteAddressFailureState extends AddressState {
  final e;

  DeleteAddressFailureState(this.e);

  @override
  List<Object> get props => [e];
}
