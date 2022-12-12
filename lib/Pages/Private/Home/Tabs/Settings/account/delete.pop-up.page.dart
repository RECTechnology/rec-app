import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/help.page.dart';
import 'package:rec/config/theme.dart';

class DeleteUserPopUp extends StatelessWidget {
  pushToScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => HelpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    return Scaffold(
      appBar: EmptyAppBar(
        context,
        title: 'DELETE_MY_USER',
        backArrow: false,
        centerTitle: true,
        crossX: true,
        closeAction: () {
          pushToScreen(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocalizedText('REQUEST_SENDED'),
            SizedBox(
              height: 18,
            ),
            LocalizedText(
              'DELETE_DESC_POP_UP',
              style: TextStyle(
                color: Color.fromRGBO(59, 59, 59, 1),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            RecActionButton(
                label: 'UNDERSTOOD',
                backgroundColor: recTheme!.primaryColor,
                onPressed: () => pushToScreen(context)),
          ],
        ),
      ),
    );
  }
}
