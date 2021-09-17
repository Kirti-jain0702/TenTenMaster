import 'package:equatable/equatable.dart';

abstract class AccountEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class FetchEvent extends AccountEvent {}

class UpdateEvent extends AccountEvent {
  final String name, image;
  UpdateEvent(this.name, this.image);
  @override
  List<Object> get props => [name, image];
}
