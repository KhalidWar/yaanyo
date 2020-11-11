import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yaanyo/models/app_user.dart';
import 'package:yaanyo/models/message.dart';

class DatabaseService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _chatRoomsCollection =
      FirebaseFirestore.instance.collection('chatRooms');
  final currentUserEmail = FirebaseAuth.instance.currentUser.email;

  Future addUserToDatabase({AppUser appUser}) async {
    return await _usersCollection.doc(appUser.email).set(appUser.toJson());
  }

  Future searchUserByEmail(String email) async {
    return await _usersCollection.where('email', isEqualTo: email).get();
  }

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

  Stream<QuerySnapshot> getChatRooms() {
    return _chatRoomsCollection
        // .where('users'[0]['email'], arrayContains: currentUserEmail)
        .snapshots();
  }

  Stream<QuerySnapshot> getCurrentUserStream() {
    return _usersCollection
        .where('email', isEqualTo: currentUserEmail)
        .snapshots();
  }

  Future updateUserName(String newName) async {
    final newNameMap = {'name': newName};
    return await _usersCollection.doc(currentUserEmail).update(newNameMap);
  }
}
