import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/Components/Forms/RegisterStepOne.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/AccountTypeHeader.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Text/TitleText.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/Forms/RegisterData.dart';
import 'package:rec/Pages/Public/Register/RegisterRequest.dart';
import 'package:rec/Pages/Public/Register/RegisterStepTwo.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';
import 'package:rec/Helpers/RecToast.dart';

class RegisterOne extends StatefulWidget {
  @override
  RegisterOneState createState() => RegisterOneState();
}

class RegisterOneState extends State<RegisterOne>
    with SingleTickerProviderStateMixin {
  RegisterData registerData = RegisterData(
    prefix: '+34',
    accountType: Account.TYPE_PRIVATE,
  );
  final _formKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<RegisterStepOneFormState>();

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

  Widget _header() {
    var bg = registerData.isAccountPrivate
        ? Brand.backgroundPrivateColor
        : Brand.backgroundCompanyColor;

    return AppBar(
      backgroundColor: bg,
      leading: IconButton(
        icon: Icon(Icons.close, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      bottom: AccountTypeHeader(
        isPrivate: registerData.isAccountPrivate,
        onChanged: (isPrivate) {
          if (isPrivate) {
            _registerFormKey.currentState.setToPrivate();
          } else {
            _registerFormKey.currentState.setToCompany();
          }
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
              CaptionText(
                registerData.isAccountPrivate
                    ? 'PROMOTE_TRADE'
                    : 'TO_START_WRITE',
              ),
              TitleText(
                'CREATE_USER',
                showTooltip: registerData.isAccountCompany,
                tooltipText: 'INTRODUCE_INFO',
                tooltipColor: Brand.accentColor,
              ),
              RegisterStepOneForm(
                key: _registerFormKey,
                formKey: _formKey,
                onChange: (data) {
                  setState(() => registerData = data);
                },
              ),
              _pressNextToAdd(),
              SizedBox(height: 8),
              _termsAndServices(),
              _registerButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerButton() {
    var localizations = AppLocalizations.of(context);
    var label = registerData.isAccountPrivate
        ? localizations.translate('REGISTER')
        : localizations.translate('NEXT');
    var background =
        registerData.isAccountPrivate ? Brand.primaryColor : Brand.accentColor;

    return RecActionButton(
      label: label,
      onPressed: next,
      icon: registerData.isAccountPrivate ? null : Icons.arrow_forward_ios,
      backgroundColor: background,
      padding: EdgeInsets.zero,
    );
  }

  Widget _termsAndServices() {
    var localizations = AppLocalizations.of(context);
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: registerData.isAccountPrivate
          ? Brand.primaryColor
          : Brand.accentColor,
      title: Text(
        localizations.translate('ACORD_WHIT_TEMS'),
        style: Theme.of(context).textTheme.caption,
      ),
      value: registerData.termsAccepted,
      onChanged: (value) => setState(
        () => registerData.termsAccepted = value,
      ),
    );
  }

  Widget _pressNextToAdd() {
    var localizations = AppLocalizations.of(context);
    return Container(
      alignment: Alignment.centerLeft,
      // margin: EdgeInsets.fromLTRB(0, 24, 0, 16),
      child: Text(
        registerData.isAccountPrivate
            ? ''
            : localizations.translate('PRESS_NEXT_TO_ADD'),
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(color: Brand.accentColor),
      ),
    );
  }

  void next() {
    if (!_formKey.currentState.validate()) return;
    if (!registerData.termsAccepted) return _showError('NO_ACORD_TERMS');
    if (registerData.isAccountCompany) return _goToRegisterCompanyPage();

    _attemptPrivateRegister();
  }

  void _goToRegisterCompanyPage() async {
    var newData = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => RegisterTwo(registerData: registerData),
      ),
    );

    if (newData == null) return;

    registerData = newData;
    _formKey.currentState.validate();
  }

  void _attemptPrivateRegister() {
    var localizations = AppLocalizations.of(context);

    RegisterRequest.tryRegister(context, registerData).then((result) {
      if (result == null || !result.error) return;

      if (result.message.contains('Server Error')) {
        return _showError('UNEXPECTED_SERVER_ERROR');
      }

      var translatedMessage = localizations.translate(result.message);
      if (translatedMessage != result.message) {
        String fieldName = result.message.split(' ').first;
        registerData.addError(
          fieldName,
          localizations.translate(result.message),
        );
        _formKey.currentState.validate();
      } else {
        _showError(translatedMessage);
      }
    });
  }

  void _showError(String message) {
    var localizations = AppLocalizations.of(context);
    RecToast.showError(
      context,
      localizations.translate('UNEXPECTED_SERVER_ERROR'),
    );
  }
}
