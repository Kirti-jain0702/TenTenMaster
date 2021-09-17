import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivoo/Converters/timestamp_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable(explicitToJson: true)
class Message {
  final int senderId;
  final String senderName;
  final int receiverId;
  final String receiverName;
  final String text;
  final int orderId;
  final String messageId;
  final String chatId;

  @TimestampConverter()
  final Timestamp time;

  final bool isRead;

  Message(
    this.senderId,
    this.senderName,
    this.receiverId,
    this.receiverName,
    this.text,
    this.orderId,
    this.messageId,
    this.chatId,
    this.time,
    this.isRead,
  );

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
