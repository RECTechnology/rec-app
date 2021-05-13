import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rec/Api/ApiError.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Api/Services/UsersService.dart';
import 'package:rec/Components/Indicators/LoadingIndicator.dart';
import 'package:rec/Entities/User.ent.dart';
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
  StreamSubscription<User> userStream;

  _PrivateRouteState(this.route);

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  void dispose() {
    super.dispose();
    if (userStream != null) userStream.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userState ??= UserState.of(context, listen: false);

    if (userState.user == null) {
      loadUser();
    } else {
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading ? LoadingIndicator() : route;
  }

  void loadUser() {
    setState(() => loading = true);
    userStream = users.getUser().asStream().listen(gotUser);
    userStream.onError((e) => gotUserError);
  }

  void gotUser(user) {
    setState(() => loading = false);
    userState.setUser(user);
  }

  void gotUserError(e) async {
    if (e.runtimeType != ApiError) return;
    if (e.code == 401 || e.code == 403) {
      await Auth.logout();
      await Navigator.of(context).pushReplacementNamed(Routes.login);
    }
  }

  void setup() {
    Auth.isLoggedIn().then(
      (isLoggedIn) {
        if (!isLoggedIn) {
          Navigator.of(context).pushReplacementNamed(Routes.login);
        }
      },
    );
  }
}
