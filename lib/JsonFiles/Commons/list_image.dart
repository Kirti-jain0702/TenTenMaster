import 'package:delivoo/JsonFiles/Commons/image.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_image.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class ListImage {
  final List<Image> images;

  ListImage(this.images);

  factory ListImage.fromJson(Map json) => _$ListImageFromJson(json);

  Map toJson() => _$ListImageToJson(this);
}
