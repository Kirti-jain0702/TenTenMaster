import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String name;
  final String email;

  ProfileState(this.name, this.email);

  @override
  List<Object> get props => [name, email];

  @override
  bool get stringify => true;
}
