import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  final String _userEmailKey = 'userEmail';
  final String _userNameKey = 'userName';

  SharedPreferences _sharedPreferences;

  Future _initSharedPref() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  Future saveUserEmail(String userEmailValue) async {
    await _initSharedPref();
    return await _sharedPreferences.setString(_userEmailKey, userEmailValue);
  }

  Future saveUserName(String userNameValue) async {
    await _initSharedPref();
    return await _sharedPreferences.setString(_userNameKey, userNameValue);
  }

  Future<String> getUserEmail() async {
    await _initSharedPref();
    return _sharedPreferences.getString(_userEmailKey);
  }

  Future<String> getUserName() async {
    await _initSharedPref();
    return _sharedPreferences.getString(_userNameKey);
  }

  Future removeUserNameAndEmail() async {
    await _initSharedPref();
    _sharedPreferences..remove(_userEmailKey)..remove(_userNameKey);
  }
}
