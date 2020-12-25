import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:yaanyo/screens/authentication/initial_screen.dart';
import 'package:yaanyo/state_management/providers.dart';

final authStateManager = ChangeNotifierProvider((ref) => AuthStateManager());

class AuthStateManager extends ChangeNotifier {
  String _email, _password, _error, _name;
  bool _isLoading;

  get email => _email;
  get password => _password;
  get name => _name;
  get error => _error;
  get isLoading => _isLoading;

  void _setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String value) {
    _error = value;
  }

  void setEmail(String input) {
    _email = input;
  }

  void setPassword(String input) {
    _password = input;
  }

  void setName(String input) {
    _name = input;
    notifyListeners();
  }

  void signIn(BuildContext context, GlobalKey<FormState> formKey) async {
    _setError(null);
    if (formKey.currentState.validate()) {
      _setIsLoading(true);
      await context
          .read(authServiceProvider)
          .signInWithEmailAndPassword(_email, _password)
          .then((value) {
        _setIsLoading(false);
        _setError(value);
      }).catchError((error, stackTrace) => _setError(error));
    }
  }

  void signUp(BuildContext context, GlobalKey<FormState> formKey) async {
    //todo fix app is stuck on loading after successful sign up
    _setError(null);
    if (formKey.currentState.validate()) {
      _setIsLoading(true);
      await context
          .read(authServiceProvider)
          .signUpWithEmailAndPassword(
              name: _name, email: _email, password: _password)
          .then((value) {
        _setIsLoading(false);
        _setError(value);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => InitialScreen()));
      }).catchError((error, stackTrace) => _setError(error));
    }
  }
}
