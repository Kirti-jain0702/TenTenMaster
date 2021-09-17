import 'package:delivoo/Chat/MessageBloc/message_bloc.dart';
import 'package:delivoo/Components/cached_image.dart';
import 'package:delivoo/Components/custom_appbar.dart';
import 'package:delivoo/Components/entry_field.dart';
import 'package:delivoo/Constants/constants.dart';
import 'package:delivoo/JsonFiles/Chat/chat.dart';
import 'package:delivoo/JsonFiles/Chat/message.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/Themes/style.dart';
import 'package:delivoo/Themes/theme_cubit.dart';
import 'package:delivoo/UtilityFunctions/make_phone_call.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'message_bubble.dart';

class ChattingPage extends StatelessWidget {
  final Chat chat;
  final int orderId;

  ChattingPage(this.chat, this.orderId);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessageBloc>(
      create: (BuildContext context) => MessageBloc(
        orderId,
        chat,
      )..add(ShowMessagesEvent()),
      child: ChattingBody(chat),
    );
  }
}

class ChattingBody extends StatefulWidget {
  final Chat chat;

  ChattingBody(this.chat);

  @override
  _ChattingBodyState createState() => _ChattingBodyState();
}

class _ChattingBodyState extends State<ChattingBody> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  MessageBloc _messageBloc;
  ThemeCubit _themeCubit;

  bool isDark = false;

  List<Message> _messages = [];

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
                child: Icon(widget.chat.chatId.contains(Constants.ROLE_VENDOR)
                    ? Icons.keyboard_arrow_left
                    : Icons.keyboard_arrow_down),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0.0),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: ListTile(
                  leading: CachedImage(
                    widget.chat.chatImage,
                    radius: 30,
                    width: 56,
                  ),
                  title: Text(
                    widget.chat.chatName,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  subtitle: Text(
                    widget.chat.chatStatus,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.phone, color: kMainColor),
                    onPressed: () => makePhoneCall(widget.chat.chatStatus),
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
        child: BlocListener<MessageBloc, MessageState>(
          listener: (context, state) {
            if (state is MessageSentState) {
              _messageController.clear();
              setState(() {});
            }
            if (state is MessageSuccessState) {
              _messages.addAll(state.messages);
              setState(() {});
              Future.delayed(
                Duration(milliseconds: 500),
                () => _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent),
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: _messages.isEmpty
                    ? Container()
                    : ListView.builder(
                        controller: _scrollController,
                        physics: BouncingScrollPhysics(),
                        itemCount: _messages.length,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20.0),
                        itemBuilder: (context, index) => MessageBubble(
                          _messages[index].senderId == widget.chat.myId,
                          _messages[index],
                        ),
                      ),
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
                      if (_messageController.text != null &&
                          _messageController.text.trim().isNotEmpty) {
                        _messageBloc.add(
                            MessageSendEvent(_messageController.text.trim()));
                      }
                    },
                  ),
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
