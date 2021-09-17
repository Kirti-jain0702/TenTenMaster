import 'package:delivoo/Constants/constants.dart';
import 'package:delivoo/JsonFiles/Order/Get/order_data.dart';
import 'package:simple_moment/simple_moment.dart';

import 'message.dart';

class Chat {
  String chatId;
  String myId;
  String dateTimeStamp;
  String timeDiff;
  String lastMessage;
  String chatName;
  String chatImage;
  String chatStatus;
  bool isGroup;
  bool isRead;

  static Chat fromMessage(Message msg, bool isMeSender) {
    Chat chat = new Chat();
    chat.chatId = isMeSender ? msg.recipientId : msg.senderId;
    chat.myId = isMeSender ? msg.senderId : msg.recipientId;
    chat.chatName = isMeSender ? msg.recipientName : msg.senderName;
    chat.chatImage = isMeSender ? msg.recipientImage : msg.senderImage;
    chat.chatStatus = isMeSender ? msg.recipientStatus : msg.senderStatus;
    chat.dateTimeStamp = msg.dateTimeStamp;
    chat.lastMessage = msg.body;
    chat.timeDiff =
        Moment.fromMillisecondsSinceEpoch(int.parse(chat.dateTimeStamp))
            .format("dd MMM, HH:mm");
    return chat;
  }

  static Chat fromOrder(OrderData orderData, String roleTo) {
    Chat chat = new Chat();
    chat.chatId = roleTo == Constants.ROLE_VENDOR
        ? "${orderData.vendor.userId}${Constants.ROLE_VENDOR}"
        : "${orderData.delivery.delivery.user.id}${Constants.ROLE_DELIVERY}";
    chat.chatImage = roleTo == Constants.ROLE_VENDOR
        ? orderData.vendor.getImage()
        : orderData
            .delivery?.delivery?.user?.mediaUrls?.images?.first?.defaultImage;
    chat.chatName = roleTo == Constants.ROLE_VENDOR
        ? orderData.vendor.name
        : orderData.delivery.delivery.user.name;
    chat.chatStatus = roleTo == Constants.ROLE_VENDOR
        ? orderData.vendor.user.mobileNumber
        : orderData.delivery?.delivery?.user?.mobileNumber;
    chat.myId = "${orderData.userId}${Constants.ROLE_USER}";
    return chat;
  }
}
