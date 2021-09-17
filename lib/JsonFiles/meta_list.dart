import 'package:json_annotation/json_annotation.dart';

part 'meta_list.g.dart';

@JsonSerializable()
class MetaList {
  final int current_page;
  final int from;
  final int last_page;
  final String path;
  final int per_page;
  final int to;
  final int total;

  MetaList(this.current_page, this.from, this.last_page, this.path,
      this.per_page, this.to, this.total);

  /// A necessary factory constructor for creating a new MetaList instance
  /// from a map. Pass the map to the generated `_$MetaListFromJson()` constructor.
  /// The constructor is named after the source class, in this case, MetaList.
  factory MetaList.fromJson(Map<String, dynamic> json) => _$MetaListFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$MetaListToJson`.
  Map<String, dynamic> toJson() => _$MetaListToJson(this);
}
