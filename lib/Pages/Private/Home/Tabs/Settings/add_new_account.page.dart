import 'package:flutter/material.dart';
import 'package:rec/Components/Forms/AddNewAccount.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/account_type_header.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Text/TitleText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/styles/paddings.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class AddNewAccountPage extends StatefulWidget {
  AddNewAccountPage({Key? key}) : super(key: key);

  @override
  _AddNewAccountPageState createState() => _AddNewAccountPageState();
}

class _AddNewAccountPageState extends State<AddNewAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _accountService = AccountsService(env: env);

  NewAccountData _newAccountData = NewAccountData();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _header() as PreferredSizeWidget?,
        body: _body(),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  Widget _header() {
    final recTheme = RecTheme.of(context);
    final backgroundColor =
        recTheme!.accountTypeBackground(_newAccountData.accountType ?? Account.TYPE_PRIVATE);

    return AppBar(
      backgroundColor: backgroundColor,
      leading: IconButton(
        icon: Icon(Icons.close, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      bottom: AccountTypeHeader(
        isPrivate: _newAccountData.isAccountPrivate,
        onChanged: (isPrivate) {
          setState(() {
            if (isPrivate) {
              _newAccountData.setToPrivate();
            } else {
              _newAccountData.setToCompany();
            }
          });
        },
      ),
    );
  }

  Widget _body() {
    final recTheme = RecTheme.of(context);
    final color = recTheme!.accountTypeColor(_newAccountData.accountType ?? Account.TYPE_PRIVATE);

    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: Paddings.page,
          child: Column(
            children: [
              CaptionText('CREATE_ACCOUNT_DESC'),
              TitleText('CREATE_ACCOUNT'),
              const SizedBox(height: 32),
              AddNewAccountForm(
                formKey: _formKey,
                data: _newAccountData,
                onChange: (data) {
                  setState(() => _newAccountData = data!);
                },
              ),
              const SizedBox(height: 32),
              RecActionButton(
                label: 'ADD_ACCOUNT',
                onPressed: _newAccountData.isValid ? _next : null,
                backgroundColor: color,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;

    Loading.show();
    _accountService
        .addAccount(_newAccountData)
        .then(_addedAccountOk)
        .catchError(_onError);
  }

  Future<void> _addedAccountOk(c) async {
    var userState = UserState.of(context, listen: false);
    await userState.getUser();

    await Loading.dismiss();
    RecToast.showSuccess(context, 'ACCOUNT_CREATED_OK');
    Navigator.pop(context);
  }

  void _onError(e) {
    Loading.dismiss();
    RecToast.showError(context, e.message);
  }
}
