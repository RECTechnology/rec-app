import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rec/Api/Services/LoginService.dart';

class ApiProvider with ChangeNotifier {
  LoginService loginService;

  ApiProvider() {
    loginService = LoginService();
  }

  static of(context, {listen = true}) {
    return Provider.of<ApiProvider>(context, listen: listen);
  }
}
