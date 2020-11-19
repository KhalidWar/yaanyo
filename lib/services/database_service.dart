import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yaanyo/models/app_user.dart';
import 'package:yaanyo/models/message.dart';
import 'package:yaanyo/models/shopping_grid.dart';
import 'package:yaanyo/models/shopping_task.dart';

class DatabaseService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _chatRoomsCollection =
      FirebaseFirestore.instance.collection('chatRooms');
  final CollectionReference _shoppingCollection =
      FirebaseFirestore.instance.collection('shopping');

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

  Stream<QuerySnapshot> getCurrentUserStream() {
    final currentUserEmail = FirebaseAuth.instance.currentUser.email;
    return _usersCollection
        .where('email', isEqualTo: currentUserEmail)
        .snapshots();
  }

  Future updateUserName(String newName) async {
    final currentUserEmail = FirebaseAuth.instance.currentUser.email;
    final newNameMap = {'name': newName};
    return await _usersCollection.doc(currentUserEmail).update(newNameMap);
  }

  Future createNewShoppingGrid({ShoppingGrid shoppingGrid}) async {
    final currentUserUID = FirebaseAuth.instance.currentUser.uid;
    _shoppingCollection
        .doc(currentUserUID)
        .collection('shoppingGrid')
        .doc(shoppingGrid.storeName)
        .set(shoppingGrid.toJson());
  }

  Stream<QuerySnapshot> getShoppingGridStream() {
    final currentUserUID = FirebaseAuth.instance.currentUser.uid;
    return _shoppingCollection
        .doc(currentUserUID)
        .collection('shoppingGrid')
        .orderBy('time', descending: false)
        .snapshots();
  }

  Future addShoppingTask({String storeName, ShoppingTask shoppingTask}) async {
    final currentUserUID = FirebaseAuth.instance.currentUser.uid;
    _shoppingCollection
        .doc(currentUserUID)
        .collection('shoppingGrid')
        .doc(storeName)
        .collection('shoppingTask')
        .doc(shoppingTask.taskLabel)
        .set(shoppingTask.toJson());
  }

  Stream<QuerySnapshot> getShoppingTaskStream(String storeName) {
    final currentUserUID = FirebaseAuth.instance.currentUser.uid;
    return _shoppingCollection
        .doc(currentUserUID)
        .collection('shoppingGrid')
        .doc(storeName)
        .collection('shoppingTask')
        .orderBy('time', descending: false)
        .snapshots();
  }

  Future toggleShoppingTask(
      {ShoppingTask shoppingTask, String storeName}) async {
    final currentUserUID = FirebaseAuth.instance.currentUser.uid;
    return await _shoppingCollection
        .doc(currentUserUID)
        .collection('shoppingGrid')
        .doc(storeName)
        .collection('shoppingTask')
        .doc(shoppingTask.taskLabel)
        .update(shoppingTask.toJson());
  }
}
