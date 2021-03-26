import 'Storage.dart';

class Auth {
  static RecStorage storage = RecStorage();
  static const String _tokenKey = 'token';
  static const String _refreshTokenKey = 'refresh_token';

  static Future<bool> isLoggedIn() async {
    return Auth.getToken() != null;
  }

  static Future<void> clear() async {
    return storage.delete(key: Auth._tokenKey);
  }

  static Future<void> saveToken(String token) async {
    return storage.write(key: Auth._tokenKey, value: token);
  }

  static Future<void> saveTokenData(Map<String, dynamic> body) async {
    // Guarda access_token
    await storage.write(
      key: Auth._tokenKey,
      value: body['access_token'],
    );

    // Guarda refresh_token
    await storage.write(
      key: Auth._refreshTokenKey,
      value: body['refresh_token'],
    );

    // Guarda fecha expiracion
    var expiresInSeconds = body['expires_in'];
    await storage.write(
      key: Auth._tokenKey,
      value: DateTime.now()
          .add(Duration(seconds: expiresInSeconds))
          .toIso8601String(),
    );
  }

  static Future<String> getToken() {
    return storage.read(key: Auth._tokenKey);
  }
}
