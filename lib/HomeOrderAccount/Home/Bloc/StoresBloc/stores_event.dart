import 'package:equatable/equatable.dart';

abstract class StoreEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class FetchStoreEvent extends StoreEvent {
  final int page;

  FetchStoreEvent(this.page);

  @override
  List<Object> get props => [page];
}
