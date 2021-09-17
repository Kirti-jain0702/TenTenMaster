part of 'message_bloc.dart';

class MessageEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class MessageSendEvent extends MessageEvent {
  final String messageBody;

  MessageSendEvent(this.messageBody);

  @override
  List<Object> get props => [messageBody];
}

class ShowMessagesEvent extends MessageEvent {}

class UpdateMessagesEvent extends MessageEvent {
  final List<Message> messages;

  UpdateMessagesEvent(this.messages);

  @override
  List<Object> get props => [messages];
}
