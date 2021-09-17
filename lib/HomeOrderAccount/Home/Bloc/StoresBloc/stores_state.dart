import 'package:delivoo/JsonFiles/Vendors/vendor_data.dart';
import 'package:delivoo/JsonFiles/base_list_response.dart';
import 'package:equatable/equatable.dart';

abstract class StoreState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadingState extends StoreState {}

class SuccessStoreState extends StoreState {
  final BaseListResponse<Vendor> listOfVendorData;

  SuccessStoreState(this.listOfVendorData);

  @override
  List<Object> get props => [listOfVendorData];
}

class FailureStoresState extends StoreState {
  final e;

  FailureStoresState(this.e);

  @override
  List<Object> get props => [e];
}
