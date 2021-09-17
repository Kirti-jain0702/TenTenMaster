import 'package:equatable/equatable.dart';

abstract class ItemsEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class FetchItemsEvent extends ItemsEvent {}
