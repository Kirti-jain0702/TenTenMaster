import 'package:json_annotation/json_annotation.dart';

part 'scope_meta.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class ScopeMetaData {
  final String scope;
  final String key;

  ScopeMetaData(this.scope, this.key);

  factory ScopeMetaData.fromJson(Map json) => _$ScopeMetaDataFromJson(json);

  Map toJson() => _$ScopeMetaDataToJson(this);
}
