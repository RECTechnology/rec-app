import 'package:flutter/material.dart';
import 'package:rec/Api/Auth.dart';

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
  _PrivateRouteState(this.route);

  @override
  void initState() {
    super.initState();

    Auth.isLoggedIn().then(
      (v) {
        if (v == false) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
        setState(() {
          loading = false;
        });
      },
    );
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
}
