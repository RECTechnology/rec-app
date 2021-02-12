import 'package:flutter/widgets.dart';
import 'package:rec/Base/View.base.dart';
import 'package:rec/Providers/AppState.dart';

class LoginView extends StatefulWidget {
  LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends ViewBaseState<LoginView> {
  _LoginViewState() : super();

  @override
  Widget buildView(BuildContext context, AppState appState) {
    return Container();
  }
}
