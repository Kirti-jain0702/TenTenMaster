import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivoo/JsonFiles/Message/message.dart';

class ChatRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //method to save messages in firestore
  saveMessages(Message message, String orderId, String innerCollection) async {
    Map map = message.toJson();
    map['chatId'] = innerCollection;
    var document = _messagesCollection(orderId, innerCollection).doc();
    map['messageId'] = document.id;
    document.set(map);
  }

//method to get stream of messages from firestore
  Stream<List<Message>> getMessages(String orderId, String innerCollection) {
    return _messagesCollection(orderId, innerCollection)
        .orderBy('time', descending: true)
        .snapshots()
        .map((qs) {
      List<Message> messages = qs.docs.map((DocumentSnapshot ds) {
        Message message = Message.fromJson(ds.data());
        return message;
      }).toList();
      return messages;
    });
  }

  setDelivered(String docId, String orderId, String innerCollection) {
    Map<String, dynamic> map = {'isRead': true};
    _messagesCollection(orderId, innerCollection).doc(docId).update(map);
  }

  CollectionReference _messagesCollection(
      String orderId, String innerCollection) {
    return _firestore
        .collection('orders')
        .doc(orderId)
        .collection(innerCollection);
  }
}
