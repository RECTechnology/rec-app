import 'package:rec/Entities/Forms/FormData.dart';

class LoginData extends FormData {
  String username;
  String password;
  int version;

  LoginData({
    this.username,
    this.password,
    this.version,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'version': version,
    };
  }
}
