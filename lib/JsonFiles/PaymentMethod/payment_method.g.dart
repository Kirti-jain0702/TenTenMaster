// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) {
  return PaymentMethod(
    json['id'] as int,
    json['slug'] as String,
    json['title'] as String,
    json['titleTranslations'] == null
        ? null
        : TitleTranslations.fromJson(
            json['titleTranslations'] as Map<String, dynamic>),
    json['enabled'] as int,
    json['type'] as String,
    json['meta'],
  );
}

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'titleTranslations': instance.titleTranslations,
      'enabled': instance.enabled,
      'type': instance.type,
      'meta': instance.dynamicMeta,
    };
