import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class AuthProvider {
  static const String _tokenKey = 'token';

  static Future<bool> isLoggedIn() async {
    return AuthProvider.getToken() != null;
  }

  static Future<void> clear() async {
    return storage.delete(key: AuthProvider._tokenKey);
  }

  static Future<void> saveToken(String token) async {
    return storage.write(key: AuthProvider._tokenKey, value: token);
  }

  static Future<String> getToken() {
    return storage.read(key: AuthProvider._tokenKey);
  }
}
