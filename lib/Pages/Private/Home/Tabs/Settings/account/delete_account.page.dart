import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/account/delete.pop-up.page.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class DeleteAccountPage extends StatefulWidget {
  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final AccountsService _accountsService = AccountsService(env: env);
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    var userState = UserState.of(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: EmptyAppBar(context, title: 'DELETE_MY_USER'),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LocalizedText('DELETE_YOUR_USER'),
              SizedBox(
                height: 18,
              ),
              LocalizedText(
                'DELETE_DESC',
                style: TextStyle(
                  color: Color.fromRGBO(59, 59, 59, 100),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              RecActionButton(
                label: 'DELETE_USER',
                backgroundColor: recTheme!.primaryColor,
                onPressed: () => _onDelete(userState.user!.id),
              ),
            ],
          ),
        ));
  }

  Future _onDelete(id) {
    Loading.show();
    return _accountsService
        .deleteAccount(id)
        .then(_deleteOk)
        .catchError(_onError);
  }

  void _deleteOk(c) {
    isLoading = false;
    Loading.dismiss();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DeleteUserPopUp()),
    );
  }

  void _onError(e) {
    isLoading = false;
    Loading.dismiss();
    RecToast.showError(context, e.message);
  }
}
