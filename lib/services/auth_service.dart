import 'package:firebase_auth/firebase_auth.dart';
import 'package:yaanyo/models/app_user.dart';

import '../constants.dart';
import 'database/user_database_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

  Future<void> signOut() async => await _firebaseAuth.signOut();
}
