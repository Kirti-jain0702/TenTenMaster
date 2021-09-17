import 'package:json_annotation/json_annotation.dart';

part 'ratings_meta.g.dart';

@JsonSerializable()
class RatingsMeta {
  @JsonKey(name: 'current_page')
  final int currentPage;
  final int from;

  @JsonKey(name: 'last_page')
  final int lastPage;
  final String path;

  @JsonKey(name: 'per_page')
  final int perPage;
  final int to;
  final int total;

  RatingsMeta(this.currentPage, this.from, this.lastPage, this.path,
      this.perPage, this.to, this.total);

  factory RatingsMeta.fromJson(Map<String, dynamic> json) =>
      _$RatingsMetaFromJson(json);

  Map<String, dynamic> toJson() => _$RatingsMetaToJson(this);
}
