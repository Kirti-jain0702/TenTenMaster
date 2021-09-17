import 'dart:async';

import 'package:delivoo/AppConfig/app_config.dart';
import 'package:delivoo/Auth/BLOC/auth_bloc.dart';
import 'package:delivoo/Auth/BLOC/auth_state.dart';
import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Components/custom_appbar.dart';
import 'package:delivoo/Components/custom_dialog.dart';
import 'package:delivoo/Components/entry_field.dart';
import 'package:delivoo/Components/show_toast.dart';
import 'package:delivoo/JsonFiles/Address/getaddress_json.dart';
import 'package:delivoo/Locale/language_cubit.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Maps/Bloc/map_bloc.dart';
import 'package:delivoo/Maps/Bloc/map_event.dart';
import 'package:delivoo/Maps/Bloc/map_state.dart';
import 'package:delivoo/Maps/Components/address_type_button.dart';
import 'package:delivoo/Maps/location_selected.dart';
import 'package:delivoo/Maps/map_repository.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/UtilityFunctions/search_places/search_map_place.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
//import 'package:search_map_place/search_map_place.dart';

TextEditingController _addressController = TextEditingController();

class LocationPage extends StatelessWidget {
  final bool pickOnly;
  final GetAddress address;

  LocationPage([this.pickOnly, this.address]);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MapBloc>(
      create: (BuildContext context) =>
          MapBloc()..add(FetchLocation(address, true)),
      child: SetLocation(pickOnly != null ? pickOnly : false, address),
    );
  }
}

class SetLocation extends StatefulWidget {
  final bool pickOnly;
  GetAddress address;

  SetLocation(this.pickOnly, this.address);

  @override
  _SetLocationState createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {
  bool isLoaderShowing = false;
  MapBloc _mapBloc;
  LanguageCubit _languageCubit;
  String defLang;

  Completer<GoogleMapController> _controller = Completer();

  bool isCard = false;
  static const platform = MethodChannel('localeChange');
/*  Future<String> getStatus(String locale) async {
    await platform.invokeMethod("locale",{"lang":locale});
  }*/
  @override
  void initState() {
    super.initState();
    _mapBloc = BlocProvider.of<MapBloc>(context);
    _languageCubit = BlocProvider.of<LanguageCubit>(context);
  //  getStatus("zh_CN");
   // getStatus("zh_CN");
/*    _languageCubit.getCurrentLanguageVal().then((value) {
      defLang = value;
      _languageCubit.setCurrentLanguage("ta", true);
    });*/
  }
  @override
  void dispose() {
 //   getStatus("en");
   // _languageCubit.setCurrentLanguage(defLang, true);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<MapBloc, MapState>(
      listener: (context, state) async {
        if (state is MapLoading) {
          showLoader();
        } else {
          dismissLoader();
        }
        if (state is MapLoaded) {
          Navigator.pop(context, state.address);
        }
        if (state is MapLoadedError) {
          showToast(
              AppLocalizations.of(context).getTranslationOf(state.message));
        }
        if (state.toAnimateCamera) {
          GoogleMapController controller = await _controller.future;
          CameraUpdate cameraUpdate = CameraUpdate.newLatLng(state.latLng);
          await controller.animateCamera(cameraUpdate);
          _mapBloc.add(MarkerMovedEvent());
        }
        if (state.goToHomePage) {
          Navigator.pop(
              context,
              LocationSelected(state.formattedAddress, state.latLng.latitude,
                  state.latLng.longitude));
        } else if (state.goToLoginPage) {
          showCustomDialog(context);
        }
      },
      child: BlocBuilder<MapBloc, MapState>(builder: (context, state) {
        return Scaffold(
//          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context).setLocation,
              style: TextStyle(fontSize: 16.7),
            ),
          ),
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 8.0,
                  ),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        GoogleMap(
                          initialCameraPosition:
                              CameraPosition(target: state.latLng, zoom: 16.0),
                          onCameraMove:
                              state.toAnimateCamera ? null : onCameraMove,
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          zoomControlsEnabled: false,
                          onMapCreated: (GoogleMapController controller) async {
                            /* String mapStyle = await MapRepository().loadSilverMap();
                            await controller.setMapStyle(mapStyle);*/
                            _controller.complete(controller);
                          },
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 36.0),
                              child: Image.asset(
                                'images/map_pin.png',
                                height: 36,
                              ),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        Image.asset('images/map_pin.png', scale: 2.5),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => getPredictions(),
                            child: Text(
                              state.formattedAddress,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  state.isCardShowing
                      ? SaveAddressCard(widget.address)
                      : Container(),
                  BottomBar(
                      text: AppLocalizations.of(context).continueText,
                      onTap: () {
                        if (widget.pickOnly) {
                          _mapBloc.add(LocationSelectionOutEvent(false,
                              state.latLng.longitude, state.latLng.latitude));
                        } else {
                          if (widget.address == null) {
                            widget.address = GetAddress.newAddress(
                                state.formattedAddress,
                                state.latLng.longitude,
                                state.latLng.latitude);
                          }
                          if (BlocProvider.of<AuthBloc>(context).state
                              is Authenticated) {
                            if (!state.isCardShowing) {
                              _addressController.text = state.formattedAddress;
                              _mapBloc.add(ShowCardEvent());
                            } else {
                              _mapBloc.add(
                                AddressSubmittedEvent(
                                    widget.address != null
                                        ? widget.address.id
                                        : -1,
                                    widget.address.title,
                                    _addressController.text,
                                    state.latLng.longitude,
                                    state.latLng.latitude),
                              );
                            }
                          } else {
                            showCustomDialog(context);
                          }
                        }
                      }),
                ],
              ),
              Positioned(
                top: 30,
                right: 10,
                left: 10,
                child: SearchMapPlaceWidget(
                  hasClearButton: true,
                  placeholder: 'Enter Address',
                  contextTop: context,
                  placeType: PlaceType.address,
                  apiKey: 'AIzaSyCgxYlKYfp8dz8JgW5UxIEX--aI8YlPxDw',
                  onSelected: (Place place) async {
                    Geolocation geolocation = await place.geolocation;
                    var controller = await _controller.future;
                    controller.animateCamera(
                        CameraUpdate.newLatLng(geolocation.coordinates));
                    controller.animateCamera(
                        CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void onCameraMove(CameraPosition position) {
    _mapBloc.add(UpdateCameraPositionEvent(position, widget.address == null));
  }

  void onLocationSelected(Prediction prediction) async {
    _mapBloc.add(LocationSelectedEvent(prediction));
  }

  showLoader() {
    if (!isLoaderShowing) {
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(kMainColor),
          ));
        },
      );
      isLoaderShowing = true;
    }
  }

  dismissLoader() {
    if (isLoaderShowing) {
      Navigator.of(context).pop();
      isLoaderShowing = false;
    }
  }

  getPredictions() async {
    Prediction prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: AppConfig.apiKey,
      language: 'en',
      mode: Mode.fullscreen,
      onError: (response) {
        print(response);
      },
    );
    onLocationSelected(prediction);
  }
}

class SaveAddressCard extends StatefulWidget {
  GetAddress address;

  SaveAddressCard(this.address);

  @override
  _SaveAddressCardState createState() => _SaveAddressCardState();
}

class _SaveAddressCardState extends State<SaveAddressCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: EntryField(
            controller: _addressController,
            label: AppLocalizations.of(context).addressLabel,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            AppLocalizations.of(context).saveAddress,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              AddressTypeButton(
                label: AppLocalizations.of(context)
                    .getTranslationOf("address_type_home"),
                image: 'images/address/ic_homeblk.png',
                onPressed: () {
                  setState(() {
                    widget.address.title = "home";
                  });
                },
                isSelected: widget.address.title == "home",
              ),
              AddressTypeButton(
                label: AppLocalizations.of(context)
                    .getTranslationOf("address_type_office"),
                image: 'images/address/ic_officeblk.png',
                onPressed: () {
                  setState(() {
                    widget.address.title = "office";
                  });
                },
                isSelected: widget.address.title == "office",
              ),
              AddressTypeButton(
                label: AppLocalizations.of(context)
                    .getTranslationOf("address_type_other"),
                image: 'images/address/ic_otherblk.png',
                onPressed: () {
                  setState(() {
                    widget.address.title = "other";
                  });
                },
                isSelected: widget.address.title == "other",
              ),
            ],
          ),
        )
      ],
    );
  }

}
