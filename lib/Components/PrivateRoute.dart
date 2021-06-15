import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rec/Api/ApiError.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Api/Services/UsersService.dart';
import 'package:rec/Components/Indicators/LoadingIndicator.dart';
import 'package:rec/Entities/User.ent.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/routes.dart';

/// This widget tries to fetch user data from the API
/// It renders the child if it was successful fetching the data.
/// Otherwise it will redirect the user back to login page.
///
/// TODO: Might need to rethink this approach, as it's a bit consfusing and hidden
class PrivateRoute extends StatefulWidget {
  final Widget child;
  PrivateRoute(this.child) : super();

  @override
  _PrivateRouteState createState() {
    return _PrivateRouteState(child);
  }
}

class _PrivateRouteState extends State<PrivateRoute> {
  final Widget child;
  bool loading = true;

  UserState userState;
  UsersService users = UsersService();
  StreamSubscription<User> userStream;

  _PrivateRouteState(this.child);

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
    return loading ? LoadingIndicator() : child;
  }

  void loadUser() {
    setState(() => loading = true);
    userStream = users.getUser().asStream().listen(gotUser);
    userStream.onError((e) => gotUserError(e));
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
