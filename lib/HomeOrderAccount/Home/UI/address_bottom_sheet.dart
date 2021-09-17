import 'package:delivoo/Auth/BLOC/auth_bloc.dart';
import 'package:delivoo/Auth/BLOC/auth_event.dart';
import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Components/progress_loader.dart';
import 'package:delivoo/Components/show_toast.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/AddressBloc/address_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/AddressBloc/address_event.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/AddressBloc/address_state.dart';
import 'package:delivoo/HomeOrderAccount/Home/Components/address_icon.dart';
import 'package:delivoo/JsonFiles/Address/getaddress_json.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Maps/UI/location_page.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/Themes/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressBottomSheetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddressBloc>(
        create: (BuildContext context) =>
            AddressBloc()..add(FetchAddressesEvent()),
        child: AddressBottomSheetBody());
  }
}

class AddressBottomSheetBody extends StatefulWidget {
  @override
  _AddressBottomSheetBodyState createState() => _AddressBottomSheetBodyState();
}

class _AddressBottomSheetBodyState extends State<AddressBottomSheetBody> {
  AddressBloc _addressBloc;

  @override
  void initState() {
    super.initState();
    _addressBloc = BlocProvider.of<AddressBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {},
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
              AppLocalizations.of(context).getTranslationOf('select_address')),
        ),
        body: BlocConsumer<AddressBloc, AddressState>(
          listener: (context, state) {
            if (state is GetSelectedAddressSuccessState) {
              Navigator.pop(context, state.address);
            } else if (state is DeleteAddressSuccessState) {
              showToast(AppLocalizations.of(context)
                  .getTranslationOf('address_deleted_successfully'));
              _addressBloc.add(FetchAddressesEvent());
            } else if (state is DeleteAddressFailureState) {
              showToast(AppLocalizations.of(context)
                  .getTranslationOf('address_not_deleted'));
            } else if (state is FailureAddressState) {
              showToast(AppLocalizations.of(context)
                  .getTranslationOf('something_went_wrong'));
              Navigator.pop(context);
              if (state.errorCode != null && state.errorCode == 401) {
                BlocProvider.of<AuthBloc>(context).add(LoggedOut());
              }
            }
          },
          builder: (context, state) {
            if (state is SuccessAddressState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  state.addresses.length == 0
                      ? Expanded(
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).savedText,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: state.addresses.length,
                              itemBuilder: (BuildContext context, int index) {
                                var address = state.addresses[index];
                                return Column(
                                  children: <Widget>[
                                    Divider(
                                      height: 6.0,
                                      color: kCardBackgroundColor,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 6.0),
                                      color: Colors.white,
                                      child: ListTile(
                                        onTap: () => _addressBloc.add(
                                            GetSelectedAddressEvent(
                                                address: address)),
                                        leading: AddressIcon(address.title),
                                        title: Padding(
                                          padding: EdgeInsets.only(
                                              left: 8.0, bottom: 8.0),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .getTranslationOf(
                                                    "address_type_${address.title}"),
                                            style: listTitleTextStyle,
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            '${address.formattedAddress} ${address.address1 ?? ''}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(fontSize: 11.7),
                                          ),
                                        ),
                                        trailing: PopupMenuButton(
                                            icon: Icon(Icons.more_vert),
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                  value: 'edit',
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .getTranslationOf(
                                                              'edit')),
                                                ),
                                                PopupMenuItem(
                                                  value: 'delete',
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .getTranslationOf(
                                                              'delete')),
                                                )
                                              ];
                                            },
                                            onSelected: (String value) async {
                                              if (value == "edit") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LocationPage(
                                                              false, address)),
                                                ).then((value) {
                                                  if (value != null &&
                                                      value is GetAddress) {
                                                    _addressBloc.add(
                                                        ShowAddressesEvent(
                                                            value));
                                                  }
                                                });
                                              } else if (value == "delete") {
                                                addressDeletionDialog(
                                                    context, address);
                                                // if (state.addresses.length > 1)
                                                //   await addressDeletionDialog(
                                                //       context, address);
                                                // else {
                                                //   showToast(AppLocalizations.of(
                                                //               context)
                                                //           .getTranslationOf(
                                                //               'there_should_be_one_address') +
                                                //       '\n' +
                                                //       AppLocalizations.of(
                                                //               context)
                                                //           .getTranslationOf(
                                                //               'add_another_address'));
                                                // }
                                              }
                                            }),
                                      ),
                                    ),
                                  ],
                                );
                              })),
                  BottomBar(
                    text: '+ ' +
                        AppLocalizations.of(context)
                            .getTranslationOf('add_new'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LocationPage()),
                    ).then((value) {
                      if (value != null && value is GetAddress) {
                        _addressBloc.add(ShowAddressesEvent(value));
                      }
                    }),
                  ),
                ],
              );
            } else {
              return ProgressLoader();
            }
          },
        ),
      ),
    );
  }

  addressDeletionDialog(BuildContext context, GetAddress address) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(address.title),
              content: Text(AppLocalizations.of(context)
                  .getTranslationOf('do_you_want_to_delete_address')),
              actions: [
                FlatButton(
                  child: Text(AppLocalizations.of(context).no),
                  textColor: kMainColor,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: kTransparentColor)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                    child: Text(AppLocalizations.of(context).yes),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: kTransparentColor)),
                    textColor: kMainColor,
                    onPressed: () {
                      _addressBloc.add(DeleteAddressEvent(address.id));
                      Navigator.pop(context);
                    })
              ],
            ));
  }
}
