import 'package:firebase_auth/firebase_auth.dart';
import 'package:yaanyo/models/app_user.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser _appUserFromUser(User user) {
    return user == null ? null : AppUser(uid: user.uid);
  }

  Stream<AppUser> get user {
    return _auth.authStateChanges().map((User user) => _appUserFromUser(user));
  }

  Future signInAnon() async {
    try {
      dynamic data = await _auth.signInAnonymously();
      print(data);
      User user = data.user;
      return _appUserFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      dynamic result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print(result);
      User user = result.user;
      return _appUserFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      dynamic result = _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print(result.toString());
      User user = result.user;
      return _appUserFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
