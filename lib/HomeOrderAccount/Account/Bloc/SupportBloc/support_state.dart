import 'package:equatable/equatable.dart';

class SupportState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class InitialSupportState extends SupportState {}

class LoadingSupportState extends SupportState {}

class SuccessSupportState extends SupportState {}

class FailureSupportState extends SupportState {
  final e;

  FailureSupportState(this.e);
  @override
  List<Object> get props => [e];
}
