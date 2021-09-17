import 'package:json_annotation/json_annotation.dart';

part 'links_json.g.dart';

@JsonSerializable()
class LinksJson {
  final String first;
  final String last;
  final String prev;
  final String next;

  LinksJson(this.first, this.last, this.prev, this.next);

  factory LinksJson.fromJson(Map<String, dynamic> json) =>
      _$LinksJsonFromJson(json);

  Map<String, dynamic> toJson() => _$LinksJsonToJson(this);
}
