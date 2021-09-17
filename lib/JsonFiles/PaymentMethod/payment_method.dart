import 'dart:convert';

import 'package:delivoo/JsonFiles/Commons/title_translations.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_method.g.dart';

@JsonSerializable()
class PaymentMethod {
  final int id;
  final String slug;
  final String title;
  final TitleTranslations titleTranslations;
  final int enabled;
  final String type;
  @JsonKey(name: 'meta')
  final dynamic dynamicMeta;

  PaymentMethod(this.id, this.slug, this.title, this.titleTranslations,
      this.enabled, this.type, this.dynamicMeta);

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);

  String getMetaStripe() {
    String toReturn;
    if (meta != null) {
      try {
        Map metaMap = jsonDecode(meta);
        if (metaMap.containsKey("public_key")) toReturn = metaMap["public_key"];
      } catch (e) {
        print("getMetaStripe: $e");
      }
    }
    return toReturn;
  }

  String get meta {
    return (dynamicMeta != null && dynamicMeta is String) ? dynamicMeta : null;
  }
}
