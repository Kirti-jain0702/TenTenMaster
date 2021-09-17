import 'package:json_annotation/json_annotation.dart';

part 'custom_delivery.g.dart';

@JsonSerializable()
class CustomDelivery {
  final String notes;

  @JsonKey(name: 'source_formatted_address')
  final String sourceFormattedAddress;

  @JsonKey(name: 'source_address_1')
  final String sourceAddress1;

  @JsonKey(name: 'source_longitude')
  final double sourceLongitude;

  @JsonKey(name: 'source_latitude')
  final double sourceLatitude;

  @JsonKey(name: 'source_contact_name')
  final String sourceContactName;

  @JsonKey(name: 'source_contact_number')
  final String sourceContactNumber;

  @JsonKey(name: 'destination_formatted_address')
  final String destinationFormattedAddress;

  @JsonKey(name: 'destination_address_1')
  final String destinationAddress1;

  @JsonKey(name: 'destination_longitude')
  final double destinationLongitude;

  @JsonKey(name: 'destination_latitude')
  final double destinationLatitude;

  @JsonKey(name: 'destination_contact_name')
  final String destinationContactName;

  @JsonKey(name: 'destination_contact_number')
  final String destinationContactNumber;

  @JsonKey(name: 'payment_method_slug')
  final String paymentMethodSlug;

  @JsonKey(name: 'meta')
  final dynamic dynamicMeta;

  // @JsonKey(name: 'delivery_mode_id')
  // final int deliveryModeId;

  CustomDelivery({
    this.notes,
    this.sourceFormattedAddress,
    this.sourceAddress1,
    this.sourceLongitude,
    this.sourceLatitude,
    this.sourceContactName,
    this.sourceContactNumber,
    this.destinationFormattedAddress,
    this.destinationAddress1,
    this.destinationLongitude,
    this.destinationLatitude,
    this.destinationContactName,
    this.destinationContactNumber,
    this.paymentMethodSlug,
    this.dynamicMeta,
    // this.deliveryModeId,
  });

  factory CustomDelivery.fromJson(Map json) => _$CustomDeliveryFromJson(json);

  Map toJson() => _$CustomDeliveryToJson(this);

  String get meta {
    return (dynamicMeta != null && dynamicMeta is String) ? dynamicMeta : "";
  }
}
