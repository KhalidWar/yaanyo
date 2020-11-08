import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yaanyo/models/app_user.dart';
import 'package:yaanyo/models/message.dart';

class DatabaseService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _chatRoomsCollection =
      FirebaseFirestore.instance.collection('chatRooms');

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

  Stream<QuerySnapshot> getConversations(String chatRoomID) {
    return _chatRoomsCollection
        .doc(chatRoomID)
        .collection('chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatRooms(String userEmail) {
    return _chatRoomsCollection
        .where('users', arrayContains: userEmail)
        .snapshots();
  }

  Future getUserData(String uid) async {}

  Future updateUserData() async {}
}
