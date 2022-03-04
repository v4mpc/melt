import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();

  IOSOptions _getIOSOptions() => const IOSOptions(
        accountName: 'melt-account',
      );

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  void addItem(String key, String value) async {
    await _storage.write(
      key: key,
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  Future<String?> getItem(String key) async {
    final result = await _storage.containsKey(key: key);
    if (result) {
      return await _storage.read(key: key);
    }
    return null;
  }

  void deleteAll() async {
    await _storage.deleteAll(
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }
}
