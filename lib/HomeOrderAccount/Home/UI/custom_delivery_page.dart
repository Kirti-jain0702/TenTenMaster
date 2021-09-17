import 'package:delivoo/AppConfig/app_config.dart';
import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Components/entry_field.dart';
import 'package:delivoo/Components/show_toast.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CustomDeliveryBloc/custom_delivery_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CustomDeliveryBloc/custom_delivery_event.dart';
import 'package:delivoo/HomeOrderAccount/Home/Bloc/CustomDeliveryBloc/custom_delivery_state.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Routes/routes.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/UtilityFunctions/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class CustomDeliveryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CustomDeliveryBloc>(
          create: (context) =>
              CustomDeliveryBloc()..add(FetchDeliveryFeeEvent()),
        ),
      ],
      child: CustomDeliveryBody(),
    );
  }
}

class CustomDeliveryBody extends StatefulWidget {
  @override
  _CustomDeliveryBodyState createState() => _CustomDeliveryBodyState();
}

class _CustomDeliveryBodyState extends State<CustomDeliveryBody> {
  CustomDeliveryBloc _deliveryBloc;
  TextEditingController pickUpController = TextEditingController();
  TextEditingController dropController = TextEditingController();
  TextEditingController valuesController = TextEditingController();
  TextEditingController instructionController = TextEditingController();
  TextEditingController sourceNameController = TextEditingController();
  TextEditingController sourceNumberController = TextEditingController();
  TextEditingController destinationNameController = TextEditingController();
  TextEditingController destinationNumberController = TextEditingController();
  double deliveryCharge = 0;

  @override
  void initState() {
    super.initState();
    _deliveryBloc = BlocProvider.of<CustomDeliveryBloc>(context);
  }

  @override
  void dispose() {
    pickUpController.dispose();
    dropController.dispose();
    valuesController.dispose();
    instructionController.dispose();
    sourceNameController.dispose();
    sourceNumberController.dispose();
    destinationNameController.dispose();
    destinationNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomDeliveryBloc, CustomDeliveryState>(
      listener: (context, state) {
        if (state is CustomDeliveryErrorState) {
          showToast(AppLocalizations.of(context)
              .getTranslationOf('something_went_wrong'));
          Navigator.pop(context);
        } else if (state.goToNextPage) {
          Navigator.pushReplacementNamed(context, PageRoutes.orderInfoPage,
              arguments: state.orderData);
        } else if (state.deliveryFee != null) {
          setState(() {
            deliveryCharge = double.parse(state.deliveryFee.deliveryFee);
          });
        }
      },
      child: Scaffold(
        backgroundColor: kCardBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
              AppLocalizations.of(context).getTranslationOf('send_package')),
          titleSpacing: 0.0,
        ),
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Divider(
                      thickness: 10.0,
                      color: kCardBackgroundColor,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Column(
                        children: <Widget>[
                          BlocBuilder<CustomDeliveryBloc, CustomDeliveryState>(
                            builder: (context, state) {
                              pickUpController.text = state.pickupAddress;
                              return EntryField(
                                controller: pickUpController,
                                image: 'images/custom/ic_pickup_pointact.png',
                                label: AppLocalizations.of(context)
                                    .getTranslationOf('pickup_address'),
                                hint: AppLocalizations.of(context)
                                    .getTranslationOf('enter_pickup_location'),
                                onTap: () async {
                                  Prediction prediction =
                                      await PlacesAutocomplete.show(
                                    context: context,
                                    apiKey: AppConfig.apiKey,
                                    language: 'en',
                                    mode: Mode.fullscreen,
                                    onError: (response) {
                                      print(response);
                                    },
                                  );
                                  _deliveryBloc
                                      .add(PickupSelectedEvent(prediction));
                                },
                                readOnly: true,
                              );
                            },
                          ),
                          BlocBuilder<CustomDeliveryBloc, CustomDeliveryState>(
                            builder: (context, state) {
                              dropController.text = state.dropAddress;
                              return EntryField(
                                controller: dropController,
                                image: 'images/custom/ic_droppointact.png',
                                label: AppLocalizations.of(context)
                                    .getTranslationOf('drop_address'),
                                hint: AppLocalizations.of(context)
                                    .getTranslationOf('enter_drop_location'),
                                readOnly: true,
                                onTap: () async {
                                  Prediction prediction =
                                      await PlacesAutocomplete.show(
                                    context: context,
                                    apiKey: AppConfig.apiKey,
                                    language: 'en',
                                    mode: Mode.fullscreen,
                                    onError: (response) {
                                      print(response);
                                    },
                                  );
                                  _deliveryBloc
                                      .add(DropSelectedEvent(prediction));
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 10.0, color: kCardBackgroundColor),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: EntryField(
                        controller: valuesController,
                        image: 'images/custom/ic_packageact.png',
                        label: AppLocalizations.of(context)
                            .getTranslationOf('select_package_type'),
                        hint: AppLocalizations.of(context)
                            .getTranslationOf('select_type_of_package'),
                        readOnly: true,
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_down,
                          color: kMainColor,
                        ),
                        onTap: () {
                          showModalBottomSheet<List<String>>(
                            context: context,
                            builder: (context) {
                              return BlocProvider(
                                create: (context) => CustomDeliveryBloc(),
                                child: ModalBottomWidget(),
                              );
                            },
                          ).then((value) {
                            valuesController.text = value.join(', ');
                            _deliveryBloc.add(ValuesSelectedEvent(value));
                          });
                        },
                      ),
                    ),
                    Divider(
                      thickness: 10.0,
                      color: kCardBackgroundColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: EntryField(
                        controller: sourceNameController,
                        label: AppLocalizations.of(context)
                            .getTranslationOf('source_contact_name'),
                        hint: AppLocalizations.of(context).fullName,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: EntryField(
                        controller: sourceNumberController,
                        label: AppLocalizations.of(context)
                            .getTranslationOf('source_contact_number'),
                        hint: AppLocalizations.of(context).mobileNumber,
                      ),
                    ),
                    Divider(
                      thickness: 10.0,
                      color: kCardBackgroundColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: EntryField(
                        controller: destinationNameController,
                        label: AppLocalizations.of(context)
                            .getTranslationOf('destination_contact_name'),
                        hint: AppLocalizations.of(context).fullName,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: EntryField(
                        controller: destinationNumberController,
                        label: AppLocalizations.of(context)
                            .getTranslationOf('destination_contact_number'),
                        hint: AppLocalizations.of(context).mobileNumber,
                      ),
                    ),
                    Divider(
                      thickness: 10.0,
                      color: kCardBackgroundColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: EntryField(
                        controller: instructionController,
                        image: 'images/custom/ic_instruction.png',
                        hint: AppLocalizations.of(context)
                            .getTranslationOf('any_instruction'),
                        border: InputBorder.none,
                        maxLines: 3,
                        maxLength: 200,
                      ),
                    ),
                    Divider(thickness: 10.0, color: kCardBackgroundColor),
                  ],
                ),
              ),
              Material(
                elevation: 8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Text(
                        AppLocalizations.of(context).paymentInfo.toUpperCase(),
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            color: kTextColor,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8),
                      ),
                      color: Colors.white,
                    ),
                    Container(
                      color: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).deliveryCharge,
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                              '${AppSettings.currencyIcon} ${deliveryCharge ?? 0.0}',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ]),
                    ),
                    // Container(
                    //   color: Colors.white,
                    //   padding:
                    //       EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                    //   child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: <Widget>[
                    //         Text(
                    //           AppLocalizations.of(context).service,
                    //           style: Theme.of(context).textTheme.caption,
                    //         ),
                    //         Text(
                    //           '${AppSettings.currencyIcon} ${((taxInPercent / 100) * cartTotal).toStringAsFixed(2)}',
                    //           style: Theme.of(context).textTheme.caption,
                    //         ),
                    //       ]),
                    // ),
                    Container(
                      color: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).amount,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      color: kMainTextColor,
                                      fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '${AppSettings.currencyIcon} $total',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ]),
                    ),
                    BottomBar(
                      text: AppLocalizations.of(context).continueText,
                      onTap: () {
                        if (pickUpController.text.isNotEmpty &&
                            dropController.text.isNotEmpty &&
                            valuesController.text.isNotEmpty &&
                            sourceNameController.text.isNotEmpty &&
                            sourceNumberController.text.isNotEmpty &&
                            destinationNameController.text.isNotEmpty &&
                            destinationNumberController.text.isNotEmpty) {
                          _deliveryBloc.add(SubmittedEvent(
                            instructionController.text,
                            sourceNameController.text,
                            sourceNumberController.text,
                            destinationNameController.text,
                            destinationNumberController.text,
                          ));
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // double taxInPercent = double.parse(AppSettings.taxPercentage);

  double get total => deliveryCharge;
}

//bottom sheets that pops up on select package type field
class ModalBottomWidget extends StatefulWidget {
  @override
  _ModalBottomWidgetState createState() => _ModalBottomWidgetState();
}

class _ModalBottomWidgetState extends State<ModalBottomWidget> {
  CustomDeliveryBloc _deliveryBloc;

  @override
  void initState() {
    super.initState();
    _deliveryBloc = BlocProvider.of<CustomDeliveryBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomDeliveryBloc, CustomDeliveryState>(
      builder: (context, deliveryState) {
        return ListView(
          children: <Widget>[
            Container(
              color: kCardBackgroundColor,
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)
                        .getTranslationOf('select_package_type_down_case'),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  RaisedButton(
                    child: Text(
                        AppLocalizations.of(context).getTranslationOf('done')),
                    onPressed: deliveryState.isEnabled
                        ? () {
                            _deliveryBloc.add(ValuesShowEvent());
                            Navigator.pop(
                                context, deliveryState.selectedValues);
                          }
                        : null,
                    disabledTextColor: kLightTextColor,
                    shape: OutlineInputBorder(
                        borderSide: BorderSide(color: kTransparentColor),
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                ],
              ),
            ),
            CheckboxGroup(
              labels: _deliveryBloc.list,
              padding: EdgeInsets.only(top: 16.0),
              onSelected: (List<String> checked) {
                _deliveryBloc.add(ValuesSelectedEvent(checked));
              },
            ),
          ],
        );
      },
    );
  }
}
