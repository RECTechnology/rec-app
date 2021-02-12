import 'package:flutter/material.dart';
import 'package:rec/Api/Providers/AuthProvider.dart';

class PrivateRoute extends StatefulWidget {
  final Widget route;
  PrivateRoute(this.route) : super();

  @override
  _PrivateRouteState createState() {
    return _PrivateRouteState(this.route);
  }
}

class _PrivateRouteState extends State<PrivateRoute> {
  final Widget route;
  bool loading = true;
  _PrivateRouteState(this.route);

  @override
  void initState() {
    super.initState();

    AuthProvider.isLoggedIn().then(
      (v) {
        if (v == false) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
        this.setState(() {
          this.loading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return this.loading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [CircularProgressIndicator()],
          )
        : this.route;
  }
}
