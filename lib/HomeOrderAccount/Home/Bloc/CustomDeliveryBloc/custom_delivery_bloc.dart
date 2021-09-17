import 'package:bloc/bloc.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CustomDeliveryBloc/custom_delivery_event.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CustomDeliveryBloc/custom_delivery_state.dart';
import 'package:delivoo/HomeOrderAccount/HomeRepository/home_repository.dart';
import 'package:delivoo/JsonFiles/CustomDelivery/delivery_fee.dart';
import 'package:delivoo/JsonFiles/Order/Get/order_data.dart';
import 'package:delivoo/Maps/map_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class CustomDeliveryBloc
    extends Bloc<CustomDeliveryEvent, CustomDeliveryState> {
  MapRepository _mapRepository = MapRepository();
  HomeRepository _homeRepository = HomeRepository();

  List<String> list = <String>[
    'Paper & Documents',
    'Flowers & Chocolates',
    'Sports & Toys item',
    'Clothes & Accessories',
    'Electronic item',
    'Household item',
    'Glass item',
  ];

  CustomDeliveryBloc()
      : super(CustomDeliveryState(
            selectedValues: [],
            isSelected: false,
            isEnabled: false,
            pickupAddress: '',
            pickupLatLng: LatLng(20.5937, 78.9629),
            dropAddress: '',
            dropLatLng: LatLng(20.5937, 78.9629),
            goToNextPage: false,
            instruction: '',
            deliveryFee: DeliveryFee('0.0')));

  @override
  Stream<CustomDeliveryState> mapEventToState(
      CustomDeliveryEvent event) async* {
    if (event is FetchDeliveryFeeEvent) {
      yield* _mapDeliveryFeeToState();
    } else if (event is ValuesSelectedEvent) {
      yield _mapValuesSelectedToState(event.valuesSelected);
    } else if (event is ValuesShowEvent) {
      yield _mapValuesShowToState();
    } else if (event is PickupSelectedEvent) {
      yield* _mapPickupSelectedToState(event.pickupPrediction);
    } else if (event is DropSelectedEvent) {
      yield* _mapDropSelectedToState(event.dropPrediction);
    } else if (event is SubmittedEvent) {
      yield* _mapSubmittedEventToState(event);
    }
  }

  Stream<CustomDeliveryState> _mapDeliveryFeeToState() async* {
    try {
      DeliveryFee deliveryFee = await _homeRepository.getDeliveryFee();
      yield CustomDeliveryState(
          selectedValues: state.selectedValues,
          isSelected: false,
          isEnabled: false,
          pickupAddress: state.pickupAddress,
          pickupLatLng: state.pickupLatLng,
          dropAddress: state.dropAddress,
          dropLatLng: state.dropLatLng,
          instruction: state.instruction,
          goToNextPage: false,
          deliveryFee: deliveryFee);
    } catch (e) {
      print(e);
    }
  }

  CustomDeliveryState _mapValuesSelectedToState(List<String> valuesSelected) {
    if (valuesSelected.length == 0) {
      return CustomDeliveryState(
          selectedValues: valuesSelected,
          isSelected: false,
          isEnabled: false,
          pickupAddress: state.pickupAddress,
          pickupLatLng: state.pickupLatLng,
          dropAddress: state.dropAddress,
          dropLatLng: state.dropLatLng,
          instruction: state.instruction,
          goToNextPage: false,
          deliveryFee: state.deliveryFee);
    } else {
      return CustomDeliveryState(
          selectedValues: valuesSelected,
          isSelected: false,
          isEnabled: true,
          pickupAddress: state.pickupAddress,
          pickupLatLng: state.pickupLatLng,
          dropAddress: state.dropAddress,
          dropLatLng: state.dropLatLng,
          instruction: state.instruction,
          goToNextPage: false,
          deliveryFee: state.deliveryFee);
    }
  }

  CustomDeliveryState _mapValuesShowToState() {
    return CustomDeliveryState(
        selectedValues: state.selectedValues,
        isSelected: true,
        isEnabled: false,
        pickupAddress: state.pickupAddress,
        pickupLatLng: state.pickupLatLng,
        dropAddress: state.dropAddress,
        dropLatLng: state.dropLatLng,
        instruction: state.instruction,
        goToNextPage: false,
        deliveryFee: state.deliveryFee);
  }

  Stream<CustomDeliveryState> _mapPickupSelectedToState(
      Prediction pickupPrediction) async* {
    PlaceDetails placeDetails =
        await _mapRepository.getPlaceDetails(pickupPrediction.placeId);
    String address = placeDetails.formattedAddress;
    LatLng latLng = _mapRepository.getLatLng(placeDetails);
    yield CustomDeliveryState(
        selectedValues: state.selectedValues,
        isSelected: false,
        isEnabled: false,
        pickupAddress: address,
        pickupLatLng: latLng,
        dropAddress: state.dropAddress,
        dropLatLng: state.dropLatLng,
        instruction: state.instruction,
        goToNextPage: false,
        deliveryFee: state.deliveryFee);
  }

  Stream<CustomDeliveryState> _mapDropSelectedToState(
      Prediction dropPrediction) async* {
    PlaceDetails placeDetails =
        await _mapRepository.getPlaceDetails(dropPrediction.placeId);
    String address = placeDetails.formattedAddress;
    LatLng latLng = _mapRepository.getLatLng(placeDetails);
    yield CustomDeliveryState(
        selectedValues: state.selectedValues,
        isSelected: false,
        isEnabled: false,
        pickupAddress: state.pickupAddress,
        pickupLatLng: state.pickupLatLng,
        dropAddress: address,
        dropLatLng: latLng,
        instruction: state.instruction,
        goToNextPage: false,
        deliveryFee: state.deliveryFee);
  }

  Stream<CustomDeliveryState> _mapSubmittedEventToState(
      SubmittedEvent event) async* {
    try {
      OrderData orderData =
          await _homeRepository.createCustomOrder(state, event);
      yield CustomDeliveryState(
          selectedValues: state.selectedValues,
          isSelected: false,
          isEnabled: false,
          pickupAddress: state.pickupAddress,
          pickupLatLng: state.pickupLatLng,
          dropAddress: state.dropAddress,
          dropLatLng: state.dropLatLng,
          instruction: event.instruction,
          goToNextPage: true,
          orderData: orderData,
          deliveryFee: state.deliveryFee);
    } catch (e) {
      print(e);
      yield CustomDeliveryErrorState();
    }
  }
}
