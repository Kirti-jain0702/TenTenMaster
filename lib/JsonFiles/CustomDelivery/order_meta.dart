import 'package:json_annotation/json_annotation.dart';

part 'order_meta.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class OrderMeta {
  final List<String> packageTypes;

  OrderMeta(this.packageTypes);

  factory OrderMeta.fromJson(Map json) => _$OrderMetaFromJson(json);

  Map toJson() => _$OrderMetaToJson(this);
}
