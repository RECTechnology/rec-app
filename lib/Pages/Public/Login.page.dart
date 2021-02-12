import 'package:flutter/widgets.dart';
import 'package:rec/Base/Page.base.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Views/Login.view.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends PageBaseState<LoginPage> {
  _LoginPageState() : super(title: 'Login');

  @override
  Widget buildPageContent(BuildContext context, AppState appState) {
    return LoginView();
  }
}
