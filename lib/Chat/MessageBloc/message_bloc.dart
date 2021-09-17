import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:delivoo/Chat/chat_repository.dart';
import 'package:delivoo/Constants/constants.dart';
import 'package:delivoo/JsonFiles/Auth/Responses/user_info.dart';
import 'package:delivoo/JsonFiles/Chat/chat.dart';
import 'package:delivoo/JsonFiles/Chat/message.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_moment/simple_moment.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final int orderId;
  final Chat chat;

  StreamSubscription<Event> _messagesStreamSubscription;

  ChatRepository _chatRepository = ChatRepository();

  MessageBloc(this.orderId, this.chat) : super(MessageLoadingState()) {
    _chatRepository.setupDatabaseReferences(
        orderId, _getChatChild(chat.myId, chat.chatId));
  }

  @override
  Future<void> close() async {
    await _unRegisterMessageUpdates();
    return super.close();
  }

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is ShowMessagesEvent) {
      yield* _mapShowMessagesToState();
    } else if (event is UpdateMessagesEvent) {
      yield* _mapUpdateMessagesToState(event.messages);
    } else if (event is MessageSendEvent) {
      yield* _mapMessageSentToState(event.messageBody);
    }
  }

  Stream<MessageState> _mapShowMessagesToState() async* {
    if (_messagesStreamSubscription == null) {
      _messagesStreamSubscription = _chatRepository
          .getMessagesFirebaseDbRef()
          .listen((Event event) => _handleFireEvent(event));
    }
  }

  Stream<MessageState> _mapMessageSentToState(String body) async* {
    final prefs = await SharedPreferences.getInstance();
    UserInformation userMe =
        UserInformation.fromJson(jsonDecode(prefs.get('user_info')));

    Message message = new Message();
    message.chatId = _getChatChild(chat.myId, chat.chatId);
    message.body = body;
    message.dateTimeStamp = "${DateTime.now().millisecondsSinceEpoch}";
    message.delivered = false;
    message.sent = true;
    message.recipientId = chat.chatId;
    message.recipientImage = chat.chatImage;
    message.recipientName = chat.chatName;
    message.recipientStatus = chat.chatStatus;
    message.senderId = chat.myId;
    message.senderName = userMe.name;
    message.senderImage = userMe.mediaUrls?.images?.first?.defaultImage;
    message.senderStatus = userMe.email;

    try {
      await _chatRepository.sendMessage(message);
      yield MessageSentState();
      String chatRole = chat.chatId.contains(Constants.ROLE_VENDOR)
          ? Constants.ROLE_VENDOR
          : Constants.ROLE_DELIVERY;
      bool notified = await _chatRepository.postNotificationContent(
          chatRole, chat.chatId.substring(0, chat.chatId.indexOf(chatRole)));
      print("notified: $notified");
    } catch (e) {
      print("sendMessage: $e");
    }
  }

  Stream<MessageState> _mapUpdateMessagesToState(
      List<Message> messages) async* {
    yield MessageSuccessState(messages);
  }

  _handleFireEvent(Event event) {
    if (event.snapshot != null && event.snapshot.value != null) {
      try {
        Map resultMap = event.snapshot.value;
        Map<String, dynamic> json = {};
        for (String key in resultMap.keys) json[key] = resultMap[key];
        Message newMessage = Message.fromJson(json);
        newMessage.timeDiff = Moment.fromMillisecondsSinceEpoch(
                int.parse(newMessage.dateTimeStamp))
            .format("dd MMM, HH:mm");
        if (newMessage.senderId != chat.myId) {
          newMessage.delivered = true;
          _chatRepository.setMessageDelivered(newMessage.id);
        }
        add(UpdateMessagesEvent([newMessage]));
      } catch (e) {
        print("requestMapCastError: $e");
      }
    }
  }

  _unRegisterMessageUpdates() async {
    if (_messagesStreamSubscription != null) {
      await _messagesStreamSubscription.cancel();
      _messagesStreamSubscription = null;
    }
  }

  _getChatChild(String userId, String myId) {
    //example: userId="9" and myId="5" -->> chat child = "5-9"
    List<String> values = [userId, myId];
    values.sort();
    return "${values[0]}-${values[1]}";
  }
}
