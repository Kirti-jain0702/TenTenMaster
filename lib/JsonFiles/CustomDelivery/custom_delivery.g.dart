// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_delivery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomDelivery _$CustomDeliveryFromJson(Map<String, dynamic> json) {
  return CustomDelivery(
    notes: json['notes'] as String,
    sourceFormattedAddress: json['source_formatted_address'] as String,
    sourceAddress1: json['source_address_1'] as String,
    sourceLongitude: (json['source_longitude'] as num)?.toDouble(),
    sourceLatitude: (json['source_latitude'] as num)?.toDouble(),
    sourceContactName: json['source_contact_name'] as String,
    sourceContactNumber: json['source_contact_number'] as String,
    destinationFormattedAddress:
        json['destination_formatted_address'] as String,
    destinationAddress1: json['destination_address_1'] as String,
    destinationLongitude: (json['destination_longitude'] as num)?.toDouble(),
    destinationLatitude: (json['destination_latitude'] as num)?.toDouble(),
    destinationContactName: json['destination_contact_name'] as String,
    destinationContactNumber: json['destination_contact_number'] as String,
    paymentMethodSlug: json['payment_method_slug'] as String,
    dynamicMeta: json['meta'],
  );
}

Map<String, dynamic> _$CustomDeliveryToJson(CustomDelivery instance) =>
    <String, dynamic>{
      'notes': instance.notes,
      'source_formatted_address': instance.sourceFormattedAddress,
      'source_address_1': instance.sourceAddress1,
      'source_longitude': instance.sourceLongitude,
      'source_latitude': instance.sourceLatitude,
      'source_contact_name': instance.sourceContactName,
      'source_contact_number': instance.sourceContactNumber,
      'destination_formatted_address': instance.destinationFormattedAddress,
      'destination_address_1': instance.destinationAddress1,
      'destination_longitude': instance.destinationLongitude,
      'destination_latitude': instance.destinationLatitude,
      'destination_contact_name': instance.destinationContactName,
      'destination_contact_number': instance.destinationContactNumber,
      'payment_method_slug': instance.paymentMethodSlug,
      'meta': instance.dynamicMeta,
    };
