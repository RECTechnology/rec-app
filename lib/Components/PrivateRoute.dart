import 'package:flutter/material.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Api/Services/UsersService.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/routes.dart';

class PrivateRoute extends StatefulWidget {
  final Widget route;
  PrivateRoute(this.route) : super();

  @override
  _PrivateRouteState createState() {
    return _PrivateRouteState(route);
  }
}

class _PrivateRouteState extends State<PrivateRoute> {
  final Widget route;
  bool loading = true;

  UserState userState;
  UsersService users = UsersService();

  _PrivateRouteState(this.route);

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userState ??= UserState.of(context);

    if (userState.user == null) {
      loadUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [CircularProgressIndicator()],
          )
        : route;
  }

  void loadUser() {
    users.getUser().then(gotUser).catchError(gotUserError);
  }

  void gotUser(user) {
    userState.setUser(user);
    setState(() => loading = false);
  }

  void gotUserError(e) async {
    if (e['code'] == 401 || e['code'] == 403) {
      await Auth.logout();
      await Navigator.of(context).pushReplacementNamed(Routes.login);
    }
  }

  void setup() {
    Auth.isLoggedIn().then(
      (v) {
        if (v == false) {
          Navigator.of(context).pushReplacementNamed(Routes.login);
        }
      },
    );
  }
}
