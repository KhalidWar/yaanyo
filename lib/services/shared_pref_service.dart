import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  SharedPreferences _sharedPreferences;

  final String _userEmailKey = 'userEmail';

  Future _initSharedPref() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  Future saveUserDetails({String userEmail, String userName}) async {
    await _initSharedPref();
    await _sharedPreferences.setString(_userEmailKey, userEmail);
  }

  Future<String> getUserDetail({String userDetailKey}) async {
    await _initSharedPref();
    return _sharedPreferences.getString(userDetailKey);
  }

  Future removeUserDetails() async {
    await _initSharedPref();
    _sharedPreferences..remove(_userEmailKey);
  }
}
