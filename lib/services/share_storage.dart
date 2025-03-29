
import 'package:shared_preferences/shared_preferences.dart';

class ShareStorage {

  Future<void> saveUserCredential(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', userId);
  }

  Future<String?> getUserCredential() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  Future<void> removeUserCredential() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
  }

}