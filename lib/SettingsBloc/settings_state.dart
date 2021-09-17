import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadingSettingsState extends SettingsState {}

class SuccessSettingsState extends SettingsState {
  SuccessSettingsState();

  @override
  List<Object> get props => [];
}

class FailureSettingsState extends SettingsState {
  final e;

  FailureSettingsState(this.e);

  @override
  List<Object> get props => [e];
}
