part of 'message_bloc.dart';

class MessageEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class MessageSentEvent extends MessageEvent {
  final Message message;

  MessageSentEvent(this.message);

  @override
  List<Object> get props => [message];
}

class ShowMessagesEvent extends MessageEvent {}

class UpdateMessagesEvent extends MessageEvent {
  final List<Message> messages;

  UpdateMessagesEvent(this.messages);

  @override
  List<Object> get props => [messages];
}
