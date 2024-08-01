import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelperID {
  static const String _phoneKey = 'phone';
  static const String _name = 'Name';
  static const String _loggedInKey = 'loggedIn';

  // Set user type
  static Future<void> setLoggedIn(bool isLogIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, isLogIn);
  }

  // Get user type
  static Future<bool?> getLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey);
  }
  // Set phone
  static Future<void> setPhone(String phone) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneKey, phone);
  }

  // Get phone
  static Future<String?> getPhone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneKey);
  }
  static Future<void> setName(String phone) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_name, phone);
  }

  // Get phone
  static Future<String?> getName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_name);
  }
}
