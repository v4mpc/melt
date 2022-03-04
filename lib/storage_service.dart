import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {

  void addItem(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<bool> authenticated(String pin) async {
    final prefs = await SharedPreferences.getInstance();
      final String? _storedPin = prefs.getString('pin');
      print(_storedPin);
      if (_storedPin == pin) {
        return true;
      } else {
        return false;
      }
    }


}
