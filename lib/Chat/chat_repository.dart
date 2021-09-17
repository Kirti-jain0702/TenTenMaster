import 'package:delivoo/AppConfig/app_config.dart';
import 'package:delivoo/Constants/constants.dart';
import 'package:delivoo/JsonFiles/Chat/message.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepository {
  final Dio dio;
  DatabaseReference _chatRef, _inboxRef;

  ChatRepository._(this.dio);

  factory ChatRepository() {
    Dio dio = Dio();
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    dio.options.headers = {
      "content-type": "application/json",
      'Accept': 'application/json'
    };
    return ChatRepository._(dio);
  }

  void setupDatabaseReferences(int orderId, String chatChild) {
    _chatRef = FirebaseDatabase.instance
        .reference()
        .child(Constants.REF_CHAT)
        .child("$orderId")
        .child(chatChild);
    _inboxRef =
        FirebaseDatabase.instance.reference().child(Constants.REF_INBOX);
  }

  Stream<Event> getMessagesFirebaseDbRef() {
    return _chatRef.limitToLast(50).onChildAdded;
  }

  Future<void> setMessageDelivered(String messageId) {
    return _chatRef.child(messageId).child("delivered").set(true);
  }

  Future<void> sendMessage(Message message) async {
    message.id = _chatRef.child(message.chatId).push().key;
    await _chatRef.child(message.id).set(message.toJson());
    await _inboxRef
        .child(message.recipientId)
        .child(message.senderId)
        .set(message.toJson());
    await _inboxRef
        .child(message.senderId)
        .child(message.recipientId)
        .set(message.toJson());
  }

  Future<bool> postNotificationContent(String roleTo, String userIdTo,
      [String title, String body]) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      const _extra = <String, dynamic>{};
      final queryParameters = <String, dynamic>{};
      if (title != null && title.isNotEmpty)
        queryParameters["message_title"] = title;
      if (body != null && body.isNotEmpty)
        queryParameters["message_body"] = body;
      final _data = <String, dynamic>{};
      _data["role"] = roleTo;
      _data["user_id"] = userIdTo;
      final _result = await dio.request<Map<String, dynamic>>(
          'api/user/push-notification',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "Authorization": "Bearer ${prefs.getString('token')}"
              },
              extra: _extra,
              baseUrl: AppConfig.baseUrl),
          data: _data);
      return _result.statusCode > 199 && _result.statusCode < 300;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
