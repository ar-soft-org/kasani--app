import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserStorage {
  static const _storage = FlutterSecureStorage();

  /// keys
  static const _keyUserName = 'username';
  static const _keyHost = 'host';
  static const _keyVendor = 'vendor';

  /// setters
  static Future<void> setUserName(String value) async {
    await _storage.write(key: _keyUserName, value: value);
  }
  static Future<void> setHost(String value) async {
    await _storage.write(key: _keyHost, value: value);
  }
  static Future<void> setVendor(String value) async {
    await _storage.write(key: _keyVendor, value: value);
  }

  /// getters
  static Future<String?> getUserName() async {
    return await _storage.read(key: _keyUserName);
  }
  static Future<String?> getHost() async {
    return await _storage.read(key: _keyHost);
  }
  static Future<String?> getVendor() async {
    return await _storage.read(key: _keyVendor);
  }

  /// deleters
  static Future<void> deleteUserName() async {
    await _storage.delete(key: _keyUserName);
  }
  static Future<void> deleteHost() async {
    await _storage.delete(key: _keyHost);
  }
  static Future<void> deleteVendor() async {
    await _storage.delete(key: _keyVendor);
  }

  
}