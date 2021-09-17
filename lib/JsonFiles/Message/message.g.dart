// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    json['senderId'] as int,
    json['senderName'] as String,
    json['receiverId'] as int,
    json['receiverName'] as String,
    json['text'] as String,
    json['orderId'] as int,
    json['messageId'] as String,
    json['chatId'] as String,
    const TimestampConverter().fromJson(json['time']),
    json['isRead'] as bool,
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'receiverId': instance.receiverId,
      'receiverName': instance.receiverName,
      'text': instance.text,
      'orderId': instance.orderId,
      'messageId': instance.messageId,
      'chatId': instance.chatId,
      'time': const TimestampConverter().toJson(instance.time),
      'isRead': instance.isRead,
    };
