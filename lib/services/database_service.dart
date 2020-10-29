import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DatabaseService({this.uid});
  final String uid;

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _chatRoomsCollection =
      FirebaseFirestore.instance.collection('chatRooms');

  Future addUserToDatabase(
      String uid, String email, String name, String profilePic) async {
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

  Future getUserData(String uid) async {}

  Future updateUserData() async {}
}
