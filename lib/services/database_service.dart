import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DatabaseService({this.uid});
  final String uid;

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _chatRoomsCollection =
      FirebaseFirestore.instance.collection('chatRooms');

  Future addUserToDatabase(
      {String uid, String email, String name, String profilePic}) async {
    return await _usersCollection.add({
      'name': name,
      'email': email,
      'uid': uid,
      'profilePic': profilePic,
    });
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

  Future addMessage(String chatRoomID, Map messageMap) async {
    return await _chatRoomsCollection
        .doc(chatRoomID)
        .collection('chats')
        .add(messageMap)
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
