import 'package:json_annotation/json_annotation.dart';

import 'meta_list.dart';

part 'base_list_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseListResponse<T> {
  final List<T> data;
  MetaList meta;

  BaseListResponse(this.data, this.meta);

  /// A necessary factory constructor for creating a new BaseListResponse instance
  /// from a map. Pass the map to the generated `_$BaseListResponseFromJson()` constructor.
  /// The constructor is named after the source class, in this case, BaseListResponse.
  factory BaseListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object json) fromJsonT,
  ) =>
      _$BaseListResponseFromJson(json, fromJsonT);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$BaseListResponseToJson`.
  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$BaseListResponseToJson(this, toJsonT);
}
