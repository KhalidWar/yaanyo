import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:yaanyo/state_management/providers.dart';

final authStateManager = ChangeNotifierProvider((ref) => AuthStateManager());

class AuthStateManager extends ChangeNotifier {
  String _email, _password, _error;
  bool _isLoading;

  get email => _email;
  get password => _password;
  get error => _error;
  get isLoading => _isLoading;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String value) {
    _error = value;
  }

  void setEmail(String input) {
    _email = input;
  }

  void setPassword(String input) {
    _password = input;
  }

  void signIn(BuildContext context, GlobalKey<FormState> formKey) {
    setError(null);
    if (formKey.currentState.validate()) {
      setIsLoading(true);
      context
          .read(authServiceProvider)
          .signInWithEmailAndPassword(_email, _password)
          .then((value) {
        setIsLoading(false);
        setError(value);
      }).catchError((error, stackTrace) => setError(error));
    } else {
      setIsLoading(false);
    }
  }
}
