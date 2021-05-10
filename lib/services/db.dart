import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  Future<QuerySnapshot> getUserByUsername(String userName) async {
    return await FirebaseFirestore.instance.collection('users').where('name', isLessThanOrEqualTo: userName).get();
  }

  Future<QuerySnapshot> getUserByEmail(String email) async {
    return await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get();
  }

  Future<void> uploadUserInfo(Map userMap) async {
    await FirebaseFirestore.instance.collection('users').add(userMap);
  }

  Future<void> createChatRoom(String chatRoomId, chatRoomMap) async {
    // print(chatRoomId);
    await FirebaseFirestore.instance.collection('ChatRoom').doc(chatRoomId).set(chatRoomMap);
  }

  Stream<QuerySnapshot> getConversationMessages(String chatRoomId) {
    return FirebaseFirestore.instance.collection('ChatRoom').doc(chatRoomId).collection('chats').orderBy("time", descending: false).snapshots();
  }

  Future<void> sendConversationMessage(String chatRoomId, chatMap) async {
    await FirebaseFirestore.instance.collection('ChatRoom').doc(chatRoomId).collection('chats').add(chatMap);
  }

  Stream<QuerySnapshot> getchatRoomsByUser(String userName) {
    return FirebaseFirestore.instance.collection('ChatRoom').where('users', arrayContains: userName).snapshots();
  }

  void getAllChanels() async {
    var re = await FirebaseFirestore.instance.collection('channels').get();
    // var id = await FirebaseFirestore.instance.collection('channels').add({
    //   "members": ["GAGG", 'casaca'],
    //   "title": "HOW WAS THE GAME",
    //   "created": Timestamp.now()
    // });
    // log(id.id.toString());
    re.docs.forEach((e) {
      log(e.data().toString());
    });
  }
}
