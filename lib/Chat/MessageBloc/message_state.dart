part of 'message_bloc.dart';

class MessageState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class MessageLoadingState extends MessageState {}

class MessageSentState extends MessageState {}

class MessageSuccessState extends MessageState {
  final List<Message> messages;

  MessageSuccessState(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessageFailureState extends MessageState {}
