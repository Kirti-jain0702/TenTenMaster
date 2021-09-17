// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message()
    ..senderName = json['senderName'] as String
    ..senderImage = json['senderImage'] as String
    ..senderStatus = json['senderStatus'] as String
    ..recipientName = json['recipientName'] as String
    ..recipientImage = json['recipientImage'] as String
    ..recipientStatus = json['recipientStatus'] as String
    ..recipientId = json['recipientId'] as String
    ..senderId = json['senderId'] as String
    ..chatId = json['chatId'] as String
    ..id = json['id'] as String
    ..timeDiff = json['timeDiff'] as String
    ..body = json['body'] as String
    ..dateTimeStamp = json['dateTimeStamp'] as String
    ..delivered = json['delivered'] as bool
    ..sent = json['sent'] as bool;
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'senderName': instance.senderName,
      'senderImage': instance.senderImage,
      'senderStatus': instance.senderStatus,
      'recipientName': instance.recipientName,
      'recipientImage': instance.recipientImage,
      'recipientStatus': instance.recipientStatus,
      'recipientId': instance.recipientId,
      'senderId': instance.senderId,
      'chatId': instance.chatId,
      'id': instance.id,
      'timeDiff': instance.timeDiff,
      'body': instance.body,
      'dateTimeStamp': instance.dateTimeStamp,
      'delivered': instance.delivered,
      'sent': instance.sent,
    };
