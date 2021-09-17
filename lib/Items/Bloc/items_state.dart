import 'package:delivoo/JsonFiles/Products/product_data.dart';
import 'package:equatable/equatable.dart';

abstract class ItemsState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadingState extends ItemsState {}

class SuccessItemsState extends ItemsState {
  final List<ProductData> products;

  SuccessItemsState(this.products);
  @override
  List<Object> get props => [products];
}

class FailureState extends ItemsState {
  final e;
  FailureState(this.e);

  @override
  List<Object> get props => [e];
}
