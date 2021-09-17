import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class NameChangedEvent extends RegisterEvent {
  final String name;

  const NameChangedEvent({@required this.name});

  @override
  List<Object> get props => [name];
}

class EmailChangedEvent extends RegisterEvent {
  final String email;

  const EmailChangedEvent({@required this.email});

  @override
  List<Object> get props => [email];
}

class SubmittedEvent extends RegisterEvent {
  final String name;
  final String email;
  final String phoneNumber;

  SubmittedEvent(
      {@required this.name, @required this.email, @required this.phoneNumber});

  @override
  List<Object> get props => [name, email, phoneNumber];
}
