import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD

class ApiProvider with ChangeNotifier {
  ApiProvider();
=======
import 'package:rec/Api/Services/LoginService.dart';

class ApiProvider with ChangeNotifier {
  LoginService loginService;

  ApiProvider() {
    loginService = LoginService();
  }
>>>>>>> 0493584ea137e446088b473d2aad0a2083ecee0b

  static of(context, {listen = true}) {
    return Provider.of<ApiProvider>(context, listen: listen);
  }
}
