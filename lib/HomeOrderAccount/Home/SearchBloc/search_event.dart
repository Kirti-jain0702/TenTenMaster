import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class SearchClearEvent extends SearchEvent {}

class SearchVendorsEvent extends SearchEvent {
  final String vendorText;
  final int catId;
  final int pageNum;

  SearchVendorsEvent(this.vendorText, this.catId, this.pageNum);

  @override
  List<Object> get props => [vendorText, catId, pageNum];
}

class SearchProductsEvent extends SearchEvent {
  final int vendorId;
  final String productText;
  final int pageNum;

  SearchProductsEvent(this.vendorId, this.productText, this.pageNum);

  @override
  List<Object> get props => [vendorId, productText, pageNum];
}
