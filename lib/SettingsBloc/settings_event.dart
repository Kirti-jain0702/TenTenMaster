import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  @override
  List<Object> get props => [];
  @override
  bool get stringify => true;
}

class FetchSettingsEvent extends SettingsEvent {}
