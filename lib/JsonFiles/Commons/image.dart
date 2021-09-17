
import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

@JsonSerializable()
class Image{
  @JsonKey(name: 'default')
  final String defaultImage;

  @JsonKey(name: 'thumb')
  final String thumbImage;

  Image(this.defaultImage,this.thumbImage);

  factory Image.fromJson(Map<String, dynamic> json) =>
      _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);
}

