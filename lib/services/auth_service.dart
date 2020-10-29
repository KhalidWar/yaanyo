import 'package:firebase_auth/firebase_auth.dart';
import 'package:yaanyo/models/app_user.dart';
import 'package:yaanyo/services/database_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseService _databaseServices = DatabaseService();

  final defaultProfilePic =
      'https://images.unsplash.com/photo-1544502062-f82887f03d1c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1427&q=80';

  AppUser _appUserFromUser(User user) {
    return user == null ? null : AppUser(uid: user.uid);
  }

  Stream<AppUser> get user {
    return _firebaseAuth
        .authStateChanges()
        .map((User user) => _appUserFromUser(user));
  }

  Future<AppUser> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      return _appUserFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<AppUser> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      await _databaseServices.addUserToDatabase(
          user.uid, user.email, user.email, defaultProfilePic);
      return _appUserFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
