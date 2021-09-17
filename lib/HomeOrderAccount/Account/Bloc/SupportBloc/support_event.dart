import 'package:equatable/equatable.dart';

class SupportEvent extends Equatable {
  final String message;

  SupportEvent(this.message);
  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}
