import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivoo/Chat/MessageBloc/message_bloc.dart';
import 'package:delivoo/Components/cached_image.dart';
import 'package:delivoo/Components/custom_appbar.dart';
import 'package:delivoo/Components/entry_field.dart';
import 'package:delivoo/JsonFiles/Message/message.dart';
import 'package:delivoo/JsonFiles/Order/Get/order_data.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/Themes/style.dart';
import 'package:delivoo/Themes/theme_cubit.dart';
import 'package:delivoo/UtilityFunctions/get_collection_name.dart';
import 'package:delivoo/UtilityFunctions/get_date.dart';
import 'package:delivoo/UtilityFunctions/make_phone_call.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'message_bubble.dart';

class ChattingPage extends StatelessWidget {
  final OrderData orderData;
  final bool isStore;

  ChattingPage(this.orderData, this.isStore);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessageBloc>(
        create: (BuildContext context) => MessageBloc(
              orderData.id,
              getCollectionName(
                orderData.userId,
                isStore ? orderData.vendorId : orderData.delivery.delivery.id,
              ),
            )..add(ShowMessagesEvent()),
        child: ChattingBody(orderData, isStore));
  }
}

class ChattingBody extends StatefulWidget {
  final OrderData order;
  final bool isStore;

  ChattingBody(this.order, this.isStore);

  @override
  _ChattingBodyState createState() => _ChattingBodyState();
}

class _ChattingBodyState extends State<ChattingBody> {
  TextEditingController _messageController = TextEditingController();
  MessageBloc _messageBloc;
  ThemeCubit _themeCubit;

  bool isDark = false;

  getTheme() async {
    bool isDarkMode = await _themeCubit.getTheme();
    if (isDarkMode != null)
      setState(() {
        isDark = isDarkMode;
      });
  }

  @override
  void initState() {
    super.initState();
    _messageBloc = BlocProvider.of<MessageBloc>(context);
    _themeCubit = BlocProvider.of<ThemeCubit>(context);
    getTheme();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(144.0),
          child: CustomAppBar(
            leading: IconButton(
              icon: Hero(
                tag: 'arrow',
                child: Icon(widget.isStore
                    ? Icons.keyboard_arrow_left
                    : Icons.keyboard_arrow_down),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0.0),
              child: Hero(
                tag: 'Delivery Boy',
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: ListTile(
                    leading: CachedImage(
                      widget.isStore
                          ? widget
                              .order.vendor.mediaUrls.images.first.defaultImage
                          : widget.order.delivery.delivery.user.mediaUrls.images
                              .first.defaultImage,
                      radius: 30,
                      width: 56,
                    ),
                    title: Text(
                      widget.isStore
                          ? widget.order.vendor.name
                          : widget.order.delivery.delivery.user.name,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    subtitle: Text(
                      widget.isStore
                          ? widget.order.createdAtFormatted
                          : AppLocalizations.of(context)
                              .getTranslationOf('delivery_partner'),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.phone, color: kMainColor),
                      onPressed: () {
                        setState(() {
                          makePhoneCall(widget.isStore
                              ? widget.order.vendor.user.mobileNumber
                              : widget
                                  .order.delivery.delivery.user.mobileNumber);
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          )),
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/chat_bg.png'),
            fit: BoxFit.cover,
            colorFilter: isDark ? invertColor : null,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                if (state is MessageSuccessState) {
                  return Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      reverse: true,
                      itemCount: state.messages.length,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
                      itemBuilder: (context, index) => MessageBubble(
                        state.messages[index].senderId == widget.order.userId,
                        state.messages[index],
                      ),
                    ),
                  );
                } else {
                  return Expanded(child: Container());
                }
              },
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 12.0),
              child: EntryField(
                controller: _messageController,
                hint: AppLocalizations.of(context).enterMessage,
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: kMainColor,
                  ),
                  onPressed: () {
                    var order = widget.order;
                    if (_messageController.text.isNotEmpty) {
                      _messageBloc.add(MessageSentEvent(Message(
                        order.userId,
                        order.user.name,
                        widget.isStore
                            ? order.vendorId
                            : order.delivery.delivery.id,
                        widget.isStore
                            ? order.vendor.name
                            : order.delivery.delivery.user.name,
                        _messageController.text,
                        order.id,
                        null,
                        null,
                        Timestamp.now(),
                        false,
                      )));
                      _messageController.clear();
                    }
                  },
                ),
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
