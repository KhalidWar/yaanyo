import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/all.dart';

final userServiceProvider =
    ChangeNotifierProvider<UserService>((ref) => UserService());

class UserService extends ChangeNotifier {
  final _usersCollection = FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> getCurrentUserStream() {
    final currentUserEmail = FirebaseAuth.instance.currentUser.email;
    return _usersCollection
        .where('email', isEqualTo: currentUserEmail)
        .snapshots();
  }

  Future<void> updateUserName(String newName) async {
    final currentUserEmail = FirebaseAuth.instance.currentUser.email;
    final newNameMap = {'name': newName};
    return await _usersCollection.doc(currentUserEmail).update(newNameMap);
  }
}
