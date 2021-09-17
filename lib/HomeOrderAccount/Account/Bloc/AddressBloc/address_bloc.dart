import 'package:bloc/bloc.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/AddressBloc/address_event.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/AddressBloc/address_state.dart';
import 'package:delivoo/HomeOrderAccount/HomeRepository/home_repository.dart';
import 'package:delivoo/JsonFiles/Address/getaddress_json.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  HomeRepository _homeRepository = HomeRepository();

  AddressBloc() : super(LoadingAddressState());

  @override
  Stream<AddressState> mapEventToState(AddressEvent event) async* {
    if (event is FetchAddressesEvent) {
      yield* _mapFetchAddressesToState();
    } else if (event is GetSelectedAddressEvent) {
      yield* _mapGetSelectedAddressToState(event.address);
    } else if (event is ClearAddressEvent) {
      yield GetSelectedAddressFailureState(null);
    } else if (event is DeleteAddressEvent) {
      yield* _mapDeleteAddressToState(event);
    } else if (event is ShowAddressesEvent) {
      yield* _mapShowAddressesToState(event);
    }
  }

  Stream<AddressState> _mapFetchAddressesToState() async* {
    yield LoadingAddressState();
    try {
      List<GetAddress> listOfAddresses = await _homeRepository.getAddress();
      yield SuccessAddressState(listOfAddresses);
    } catch (e) {
      throw FailureAddressState(e);
    }
  }

  Stream<AddressState> _mapShowAddressesToState(
      ShowAddressesEvent event) async* {
    if (event.address != null && state is SuccessAddressState) {
      yield LoadingAddressState();
      List<GetAddress> addresses = (state as SuccessAddressState).addresses;
      int existingIndex = -1;
      for (int i = 0; i < addresses.length; i++) {
        if (addresses[i].id == event.address.id) {
          existingIndex = i;
          break;
        }
      }
      if (existingIndex == -1) {
        addresses.insert(0, event.address);
      } else {
        addresses[existingIndex] = event.address;
      }
      GetAddress addressSelected = await _homeRepository.getSelectedAddress();
      if (addressSelected != null && addressSelected.id == event.address.id) {
        _homeRepository.setSelectedAddress(event.address);
      }
      yield SuccessAddressState(addresses);
    }
  }

  Stream<AddressState> _mapGetSelectedAddressToState(
      GetAddress address) async* {
    yield LoadingAddressState();
    if (address != null) {
      await _homeRepository.setSelectedAddress(address);
      yield GetSelectedAddressSuccessState(address);
    } else {
      try {
        GetAddress address = await _homeRepository.getSelectedAddress();
        yield GetSelectedAddressSuccessState(address);
      } catch (e) {
        yield GetSelectedAddressFailureState(e);
      }
    }
  }

  Stream<AddressState> _mapDeleteAddressToState(
      DeleteAddressEvent event) async* {
    yield DeletingAddressState();
    try {
      GetAddress addressSelected = await _homeRepository.getSelectedAddress();
      if (addressSelected != null && addressSelected.id == event.addressId) {
        _homeRepository.setSelectedAddress(null);
      }
      await _homeRepository.deleteAddress(event.addressId);
      yield DeleteAddressSuccessState();
    } catch (e) {
      yield DeleteAddressFailureState(e);
    }
  }
}
