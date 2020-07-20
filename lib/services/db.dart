import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  getUserByUsername(String userName) async {
    return await Firestore.instance
        .collection('users')
        .where('name', isEqualTo: userName)
        .getDocuments();
  }

  getUserByEmail(String email) async {
    return await Firestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .getDocuments();
  }

  uploadUserInfo(Map userMap) async {
    await Firestore.instance.collection('users').add(userMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap) async {
    await Firestore.instance
        .collection('ChatRoom')
        .document(chatRoomId)
        .setData(chatRoomMap);
  }

  getConversationMessages(String chatRoomId) {
    return Firestore.instance
        .collection('ChatRoom')
        .document(chatRoomId)
        .collection('chats')
        .orderBy("time", descending: false)
        .snapshots();
  }

  sendConversationMessage(String chatRoomId, chatMap) async {
    await Firestore.instance
        .collection('ChatRoom')
        .document(chatRoomId)
        .collection('chats')
        .add(chatMap);
  }

  getchatRoomsByUser(String userName) {
    return Firestore.instance
        .collection('ChatRoom')
        .where('users', arrayContains: userName)
        .snapshots();
  }
}
