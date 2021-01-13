import 'package:firebase_auth/firebase_auth.dart';

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
      String email, String password, String name) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return null;
    } catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async => await _firebaseAuth.signOut();
}
