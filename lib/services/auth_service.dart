import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaanyo/models/app_user.dart';

import '../constants.dart';
import 'database/user_database_service.dart';

final authServiceProvider =
    ChangeNotifierProvider<AuthService>((ref) => AuthService());

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _userDBService = UserDatabaseService();

  Stream<User> userStream() => _firebaseAuth.authStateChanges();

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return null;
    } catch (e) {
      return e.message;
    }
  }

  Future<String> signUpWithEmailAndPassword(
      {String email, String password, String name}) async {
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        final appUser = AppUser(
            name: name,
            email: email,
            uid: value.user.uid,
            profilePic: kDefaultProfilePic);
        await UserDatabaseService().addUserToDatabase(appUser: appUser);
      });
      return null;
    } catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      await _firebaseAuth.signOut();
      notifyListeners();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
