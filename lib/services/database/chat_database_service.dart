import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:yaanyo/models/message.dart';

final chatDatabaseServiceProvider = ChangeNotifierProvider<ChatDatabaseService>(
  (ref) => ChatDatabaseService(),
);

class ChatDatabaseService extends ChangeNotifier {
  final CollectionReference _chatRoomsCollection =
      FirebaseFirestore.instance.collection('chatRooms');

  Future createChatRoom(String chatRoomID, Map chatRoomMap) async {
    return await _chatRoomsCollection
        .doc(chatRoomID)
        .set(chatRoomMap)
        .catchError((e) => print(e.toString()));
  }

  Future addMessage(String chatRoomID, Message message) async {
    return await _chatRoomsCollection
        .doc(chatRoomID)
        .collection('chats')
        .add(message.toJson())
        .catchError((e) => print(e.toString()));
  }

  Stream<QuerySnapshot> getChatMessages(String chatRoomID) {
    return _chatRoomsCollection
        .doc(chatRoomID)
        .collection('chats')
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<String> getLastMessage(String chatRoomID) async {
    return await _chatRoomsCollection
        .doc(chatRoomID)
        .collection('chats')
        .orderBy('time', descending: true)
        .get()
        .then((value) => value.docs[0].data()['message']);
  }

  Stream<QuerySnapshot> getChatRooms() {
    final currentUserEmail = FirebaseAuth.instance.currentUser.email;
    return _chatRoomsCollection
        .where('emails', arrayContains: currentUserEmail)
        .snapshots();
  }
}
