import 'package:delivoo/JsonFiles/Message/message.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/Themes/style.dart';
import 'package:delivoo/UtilityFunctions/read_timestamp.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final Message message;

  MessageBubble(this.isMe, this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            elevation: 4.0,
            color: isMe
                ? Theme.of(context).primaryColor
                : Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(6.0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    message.text,
                    style: isMe
                        ? bottomBarTextStyle
                        : Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(fontSize: 15.0),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        readTimestamp(message.time.seconds),
                        style: TextStyle(
                          fontSize: 10.0,
                          color: isMe
                              ? kWhiteColor.withOpacity(0.75)
                              : kLightTextColor,
                        ),
                      ),
                      isMe
                          ? Icon(
                              Icons.check_circle,
                              color:
                                  message.isRead ? Colors.blue : kDisabledColor,
                              size: 12.0,
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
