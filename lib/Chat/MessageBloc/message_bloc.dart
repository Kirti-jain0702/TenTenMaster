import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delivoo/Chat/chat_repository.dart';
import 'package:delivoo/JsonFiles/Message/message.dart';
import 'package:equatable/equatable.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final int orderId;
  final String innerCollection;

  MessageBloc(this.orderId, this.innerCollection)
      : super(MessageLoadingState());

  StreamSubscription _subscription;

  ChatRepository _chatRepository = ChatRepository();

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is MessageSentEvent) {
      yield* _mapMessageSentToState(event.message);
    } else if (event is ShowMessagesEvent) {
      yield* _mapShowMessagesToState();
    } else if (event is UpdateMessagesEvent) {
      yield* _mapUpdateMessagesToState(event.messages);
    }
  }

  Stream<MessageState> _mapMessageSentToState(Message message) async* {
    try {
      await _chatRepository.saveMessages(
          message, orderId.toString(), innerCollection);
    } catch (e) {
      print(e);
    }
  }

  Stream<MessageState> _mapShowMessagesToState() async* {
    _subscription?.cancel();
    _subscription = _chatRepository
        .getMessages(orderId.toString(), innerCollection)
        .listen((messages) {
      add(UpdateMessagesEvent(messages));
    });
  }

  Stream<MessageState> _mapUpdateMessagesToState(
      List<Message> messages) async* {
    yield MessageSuccessState(messages);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
