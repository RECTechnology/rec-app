import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Text/styled_text.dart';
import 'package:rec/config/routes.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/providers/All.dart';
import 'package:rec/styles/paddings.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ConnectaServiceNotActive extends StatefulWidget {
  ConnectaServiceNotActive({Key? key}) : super(key: key);

  @override
  State<ConnectaServiceNotActive> createState() => _ConnectaServiceNotActiveState();
}

class _ConnectaServiceNotActiveState extends State<ConnectaServiceNotActive> {
  final AccountsService _accountsService = AccountsService(env: env);

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: EmptyAppBar(context, title: 'CONNECT_TITLE'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Icon(Icons.swap_calls, color: recTheme?.primaryColor, size: 64),
                    const SizedBox(height: 16),
                    LocalizedStyledText(
                      'CONNECTA_ACTIVATE_SERVICE',
                      style: theme.textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: recTheme?.grayDark,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    LocalizedText(
                      'CONNECTA_ACTIVATE_SERVICE_DESC',
                      style: theme.textTheme.bodyText1!.copyWith(
                        color: recTheme?.grayDark,
                        height: 1.3,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24).copyWith(bottom: 32),
            child: RecActionButton(
              padding: Paddings.button.copyWith(top: 0),
              label: 'ACTIVATE_SERVICE',
              onPressed: () {
                _activateProducts();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _activateProducts() async {
    final id = UserState.deaf(context).account!.id;
    try {
      Loading.show();
      await _accountsService.activateB2BProductsForAccount(id);
      await UserState.deaf(context).getUser();
      Navigator.pushReplacementNamed(context, Routes.settingsConnectaActive);
    } catch (e) {
      RecToast.showError(context, e.toString());
    }
    Loading.dismiss();
  }
}
