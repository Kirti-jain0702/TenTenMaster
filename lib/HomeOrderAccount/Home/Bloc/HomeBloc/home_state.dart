import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final List<String> addresses;
  final String selectedValue;
  final bool goToNextPage;

  HomeState(this.addresses, this.selectedValue, this.goToNextPage);

  @override
  List<Object> get props =>
      [addresses, selectedValue, goToNextPage];

  @override
  bool get stringify => true;
}
