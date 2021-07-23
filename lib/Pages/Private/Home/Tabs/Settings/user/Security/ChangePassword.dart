import 'package:flutter/material.dart';
import 'package:rec/Api/Services/SecurityService.dart';
import 'package:rec/Api/Services/UserSmsService.dart';
import 'package:rec/Components/Forms/ChangePassword.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Entities/Forms/ChangePasswordData.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Public/SmsCode/SmsCode.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordPage> {
  final _securityService = SecurityService();
  final _smsService = UserSmsService();
  final _formKey = GlobalKey<FormState>();

  ChangePasswordData data = ChangePasswordData();

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: EmptyAppBar(
          context,
          title: localizations.translate('CHANGE_PASSWORD'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: Paddings.page,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChangePasswordForm(
                  formKey: _formKey,
                  onChangeOldPassword: changedOldPassword,
                  onChangePassword: changedPassword,
                  onChangeRePassword: changedRePassword,
                ),
                if (data.password != data.repassword)
                  LocalizedText(
                    'PASSWORDS_DO_NOT_MATCH',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: Colors.red),
                  ),
                RecActionButton(
                  label: localizations.translate('UPDATE'),
                  backgroundColor: Brand.primaryColor,
                  onPressed: data.isValid ? () => update() : null,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changedOldPassword(String string) {
    setState(() => data.oldPassword = string);
  }

  void changedPassword(String string) {
    setState(() => data.password = string);
  }

  void changedRePassword(String string) {
    setState(() => data.repassword = string);
  }

  void update() {
    if (!_formKey.currentState.validate()) return;

    Loading.show();

    _sendSmsCode().then(_goToEnterSmsCode).catchError(_onError);
  }

  Future _sendSmsCode() {
    return _smsService.sendChangePasswordSms();
  }

  Future<void> _goToEnterSmsCode(d) async {
    var userState = UserState.of(context, listen: false);

    await Loading.dismiss();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => SmsCode(
          prefix: userState.user.prefix,
          phone: userState.user.phone,
          dni: userState.user.username,
          onCode: (code) {
            Navigator.pop(context);

            setState(() => data.smsCode = code);

            _tryChangePassword();
          },
        ),
      ),
    );
  }

  Future _tryChangePassword() {
    Loading.show();
    return _securityService
        .changePassword(data)
        .then(_changePasswordOK)
        .catchError(_onError);
  }

  void _changePasswordOK(result) {
    Loading.dismiss();
    RecToast.showSuccess(context, 'CHANGE_PASSWORD_OK');
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  void _onError(error) {
    var localizations = AppLocalizations.of(context);
    Loading.dismiss();
    RecToast.showError(
      context,
      localizations.translate(error.message),
    );
  }
}
