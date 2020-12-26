import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:yaanyo/models/app_user.dart';

final userDatabaseServiceProvider = ChangeNotifierProvider<UserDatabaseService>(
  (ref) => UserDatabaseService(),
);

class UserDatabaseService extends ChangeNotifier {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future addUserToDatabase({AppUser appUser}) async {
    return await _usersCollection.doc(appUser.email).set(appUser.toJson());
  }

  Future<QuerySnapshot> searchUserByEmail(String email) async {
    return await _usersCollection.where('email', isEqualTo: email).get();
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
}
