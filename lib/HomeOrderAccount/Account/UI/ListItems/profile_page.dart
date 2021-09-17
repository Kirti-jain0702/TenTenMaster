import 'dart:convert';
import 'dart:io';
import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Components/cached_image.dart';
import 'package:delivoo/Components/entry_field.dart';
import 'package:delivoo/Components/show_toast.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/AccountBloc/account_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/AccountBloc/account_event.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/AccountBloc/account_state.dart';
import 'package:delivoo/JsonFiles/Auth/Responses/user_info.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:file_picker/file_picker.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title:
            Text(AppLocalizations.of(context).getTranslationOf("profileInfo")),
      ),
      body: BlocProvider<AccountBloc>(
        create: (context) => AccountBloc()..add(FetchEvent()),
        child: ProfileBody(),
      ),
    );
  }
}

class ProfileBody extends StatefulWidget {
  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  TextEditingController _nameController = TextEditingController();

  UserInformation _userInformation;
  String image, newImage;
  ProgressDialog _pr;
  bool isLoaderShowing = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<String> getImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['jpeg', 'png']);
    var uuid = Uuid().v1();
    if (result != null) {
      var imageFile = File(result.files.single.path);
      final Reference reference = FirebaseStorage.instance
          .ref()
          .child('delivoo/${(_userInformation?.id ?? -1)}')
          .child(uuid + imageFile.uri.pathSegments.last);
      final UploadTask uploadTask = reference.putFile(imageFile);

      String imageUrl = await uploadTask
          .whenComplete(() {})
          .then((snapshot) => snapshot.ref.getDownloadURL());

      return imageUrl;
    } else {
      showToast(
          AppLocalizations.of(context).getTranslationOf('no_image_selected'));
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is SuccessState) {
          _userInformation = state.userInformation;
          _nameController.text = _userInformation.name;
          image = _userInformation?.mediaUrls?.images?.first?.defaultImage;
          setState(() {});
        }
        if (state is LoadingUpdateUserState) {
          showLoader();
        } else {
          dismissLoader();
        }
        if (state is SuccessUpdateUserState) {
          Navigator.pop(context, state.userInformation);
        }
      },
      child: _userInformation == null
          ? Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(kMainColor),
              ),
            )
          : Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    Divider(thickness: 8.0),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        AppLocalizations.of(context)
                            .getTranslationOf("featureImage"),
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.67,
                            color: kHintColor),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await showProgress();
                        String value = await getImage();
                        await dismissProgress();
                        if (value != null) {
                          setState(() {
                            newImage = value;
                          });
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: kCardBackgroundColor,
                              ),
                              height: 100.0,
                              width: 100.0,
                              margin: EdgeInsetsDirectional.only(
                                  start: 20, bottom: 20),
                              child: newImage != null
                                  ? CachedImage(newImage,
                                      height: 100, width: 100)
                                  : image != null
                                      ? CachedImage(image,
                                          height: 100, width: 100)
                                      : Image(
                                          image:
                                              AssetImage('images/empty_dp.png'),
                                          height: 100,
                                          width: 100,
                                        ),
                            ),
                          ),
                          SizedBox(width: 30.0),
                          Icon(Icons.camera_alt, color: kMainColor, size: 20.0),
                          SizedBox(width: 14.3),
                          Text(
                              AppLocalizations.of(context)
                                  .getTranslationOf("upload"),
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(color: kMainColor)),
                        ],
                      ),
                    ),
                    Divider(thickness: 8.0),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)
                                .getTranslationOf("profileInfo"),
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.67,
                                    color: kHintColor),
                          ),
                          //name textField
                          EntryField(
                            controller: _nameController,
                            label: AppLocalizations.of(context).fullName,
                          ),
                          EntryField(
                            label: AppLocalizations.of(context).mobileNumber,
                            initialValue: _userInformation.mobileNumber,
                            readOnly: true,
                          ),
                          //email textField
                          EntryField(
                            label: AppLocalizations.of(context).emailAddress,
                            initialValue: _userInformation.email,
                            readOnly: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomBar(
                      text:
                          AppLocalizations.of(context).getTranslationOf("save"),
                      onTap: () {
                        if (_nameController.text.trim().isEmpty) {
                          showToast(AppLocalizations.of(context)
                              .getTranslationOf("invalidName"));
                        } else {
                          BlocProvider.of<AccountBloc>(context)
                              .add(UpdateEvent(_nameController.text, newImage));
                        }
                      }),
                )
              ],
            ),
    );
  }

  showProgress() async {
    if (_pr == null) {
      _pr = ProgressDialog(context,
          type: ProgressDialogType.Normal,
          isDismissible: false,
          showLogs: false);
      _pr.style(
        message: AppLocalizations.of(context).getTranslationOf("uploading"),
      );
    }
    await _pr.show();
  }

  Future<bool> dismissProgress() {
    return _pr.hide();
  }

  showLoader() {
    if (!isLoaderShowing) {
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
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
}
