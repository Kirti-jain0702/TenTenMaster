import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  String senderName;
  String senderImage;
  String senderStatus;
  String recipientName;
  String recipientImage;
  String recipientStatus;
  String recipientId;
  String senderId;
  String chatId;
  String id;
  String timeDiff;
  String body;
  String dateTimeStamp;
  bool delivered;
  bool sent;

  Message();

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
