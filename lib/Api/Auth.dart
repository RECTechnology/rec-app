import 'Storage.dart';

class Auth {
  static RecStorage storage = RecStorage();
  static const String _tokenKey = 'token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String expireDate = 'expires_in';

  static const String _appTokenKey = 'app_token';

  static Future<void> logout() async {
    await storage.delete(key: Auth._tokenKey);
    await storage.delete(key: Auth._refreshTokenKey);
    await storage.delete(key: Auth.expireDate);
  }

  // TODO: we must check if session is expired
  static Future<bool> isLoggedIn() async {
    return Auth.getAccessToken() != null;
  }

  static Future<void> clear() async {
    return storage.delete(key: Auth._tokenKey);
  }

  static Future<void> saveAccessToken(String token) async {
    return storage.write(key: Auth._tokenKey, value: token);
  }

  static Future<void> saveRefreshToken(String token) async {
    return storage.write(key: Auth._refreshTokenKey, value: token);
  }

  static Future<void> saveTokenExpireDate(int expiresInSeconds) async {
    return storage.write(
      key: Auth.expireDate,
      value: DateTime.now()
          .add(Duration(seconds: expiresInSeconds))
          .toIso8601String(),
    );
  }

  static Future<void> saveAppToken(String token) async {
    return storage.write(key: Auth._appTokenKey, value: token);
  }

  static Future<void> saveAppTokenData(Map<String, dynamic> body) async {
    await saveAppToken(body['access_token']);
  }

  static Future<void> saveTokenData(Map<String, dynamic> body) async {
    await saveAccessToken(body['access_token']);
    await saveRefreshToken(body['refresh_token']);
    await saveTokenExpireDate(body['expires_in']);
  }

  static Future<String> getAccessToken() {
    return storage.read(key: Auth._tokenKey);
  }

  static Future<String> getAppToken() {
    return storage.read(key: Auth._appTokenKey);
  }
}
