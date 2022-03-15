import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rec/config/assets.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/AppState.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/config/routes.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

/// This widgets inits the app, it checks if the user has been authenticated before and has tokens.
/// * If it has tokens, it fetched inital data and navigates to [routeIfLoggedIn] (by default [Routes.home] )
/// * It it has no tokens, it navigates to [routeIfNotLoggedIn] (by default [Routes.login] )
class InitPage extends StatefulWidget {
  final Function? ifLoggedIn;
  final Function? ifNotLoggedIn;

  const InitPage({
    Key? key,
    this.ifLoggedIn,
    this.ifNotLoggedIn,
  }) : super(key: key);

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  final _loginService = LoginService(env: env);

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  Future<void> checkAuth() async {
    var hasAccessToken = (await Auth.getAccessToken()) != null;
    return hasAccessToken ? _attemptRefresh() : _onNotLoggedIn();
  }

  Future<void> _attemptRefresh() async {
    try {
      var refreshToken = await Auth.getRefreshToken();

      await _loginService.refreshToken(refreshToken ?? '');
      await _fetchInitialData();

      return _onLoggedIn();
    } catch (e) {
      return _onNotLoggedIn();
    }
  }

  void _onLoggedIn() {
    if (widget.ifLoggedIn != null) {
      widget.ifLoggedIn!();
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.home);
    }
  }

  void _onNotLoggedIn() {
    if (widget.ifNotLoggedIn != null) {
      widget.ifNotLoggedIn!();
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.login);
    }
  }

  Future<User> _fetchInitialData() {
    var userProvider = UserState.of(context, listen: false);
    return userProvider.getUser();
  }

  @override
  Widget build(BuildContext context) {
    var app = AppState.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                child: Image.asset(
                  Assets.logo,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Center(
          child: Text(
            'v${app.version}',
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Brand.grayDark),
          ),
        ),
      ),
    );
  }
}
