import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class Uninitialized extends AuthState {}

class Authenticated extends AuthState {}

class Unauthenticated extends AuthState {}

class RestartState extends AuthState {}
