import 'package:flutter/material.dart';
import 'package:rec/Api/Services/AccountsService.dart';
import 'package:rec/Components/Forms/AddNewAccount.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/AccountTypeHeader.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Text/TitleText.dart';
import 'package:rec/Entities/Forms/NewAccountData.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';

class AddNewAccountPage extends StatefulWidget {
  AddNewAccountPage({Key key}) : super(key: key);

  @override
  _AddNewAccountPageState createState() => _AddNewAccountPageState();
}

class _AddNewAccountPageState extends State<AddNewAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _accountService = AccountsService();

  NewAccountData _newAccountData = NewAccountData();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _header(),
        body: _body(),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  Color get backgroundColor => _newAccountData.isAccountPrivate
      ? Brand.backgroundPrivateColor
      : Brand.backgroundCompanyColor;

  Color get color =>
      _newAccountData.isAccountPrivate ? Brand.primaryColor : Brand.accentColor;

  Widget _header() {
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
                  setState(() => _newAccountData = data);
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
    if (!_formKey.currentState.validate()) return;

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
