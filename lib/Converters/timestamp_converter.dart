import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class TimestampConverter implements JsonConverter<Timestamp, dynamic> {
  const TimestampConverter();

  @override
  Timestamp fromJson(json) {
    return json as Timestamp;
  }

  @override
  toJson(Timestamp object) {
    return object;
  }
}
