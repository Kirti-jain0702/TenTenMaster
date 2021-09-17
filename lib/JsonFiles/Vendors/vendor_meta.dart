import 'package:json_annotation/json_annotation.dart';

part 'vendor_meta.g.dart';

@JsonSerializable(anyMap: true)
class VendorMeta {
  final String time;

  VendorMeta(this.time);

  factory VendorMeta.fromJson(Map json) => _$VendorMetaFromJson(json);

  Map toJson() => _$VendorMetaToJson(this);
}
