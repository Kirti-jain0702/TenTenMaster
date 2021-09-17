import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Components/entry_field.dart';
import 'package:delivoo/Components/show_toast.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/SupportBloc/support_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/SupportBloc/support_event.dart';
import 'package:delivoo/HomeOrderAccount/Account/Bloc/SupportBloc/support_state.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SupportBloc>(
      create: (context) => SupportBloc(),
      child: SupportBody(),
    );
  }
}

class SupportBody extends StatefulWidget {
  @override
  _SupportBodyState createState() => _SupportBodyState();
}

class _SupportBodyState extends State<SupportBody> {
  TextEditingController _controller = TextEditingController();

  SupportBloc _supportBloc;

  @override
  void initState() {
    super.initState();
    _supportBloc = BlocProvider.of<SupportBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SupportBloc, SupportState>(
      listener: (context, state) {
        if (state is SuccessSupportState) {
          showToast(AppLocalizations.of(context)
              .getTranslationOf('support_has_been_submitted'));
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          title: Text(AppLocalizations.of(context).support,
              style: Theme.of(context).textTheme.bodyText1),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 48.0),
                    color: Theme.of(context).cardColor,
                    child: Image(
                      image: AssetImage("images/logos/logo_user.png"),
                      height: 130.0,
                      width: 99.7,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 8.0, top: 16.0),
                          child: Text(
                            AppLocalizations.of(context).orWrite,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
                          child: Text(
                            AppLocalizations.of(context).yourWords,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                        EntryField(
                          image: 'images/icons/ic_mail.png',
                          label: AppLocalizations.of(context).message,
                          hint: AppLocalizations.of(context).enterMessage,
                          maxLines: 2,
                          controller: _controller,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 300,),
                ],
              ),
            ),
            BottomBar(
              text: AppLocalizations.of(context).submit,
              onTap: _controller.text != ''
                  ? () => _supportBloc.add(SupportEvent(_controller.text))
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
