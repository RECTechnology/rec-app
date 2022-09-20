import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/app_provider.dart';
import 'package:rec/providers/user_state.dart';
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
    final hasAccessToken = (await Auth.getAccessToken()) != null;
    return hasAccessToken ? _attemptRefresh() : _onNotLoggedIn();
  }

  Future<void> _attemptRefresh() async {
    try {
      final refreshToken = await Auth.getRefreshToken();

      await _loginService.refreshToken(refreshToken ?? '');
      await _fetchInitialData();

      return _onLoggedIn();
    } catch (e) {
      RecToast.showError(context, e.toString());
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

  Future _fetchInitialData() async {
    final userProvider = UserState.of(context, listen: false);
    final appProvider = AppProvider.of(context, listen: false);

    await userProvider.getUser();
    await appProvider.loadConfigurationSettings();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = AppProvider.of(context);
    final recTheme = RecTheme.of(context);
    final assets = recTheme!.assets;

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
                  assets.logo,
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
            'v${appProvider.version}',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(color: recTheme.grayDark),
          ),
        ),
      ),
    );
  }
}
