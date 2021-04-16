import 'package:rec/Entities/Forms/FormData.dart';

class LoginData extends FormData {
  String username;
  String password;

  LoginData({this.username, this.password});

  @override
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
