import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/Components/Forms/RegisterStepOne.form.dart';
import 'package:rec/Components/Info/InfoTooltip.dart';
import 'package:rec/Components/RecActionButton.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/Forms/RegisterData.dart';
import 'package:rec/Pages/Public/Register/RegisterRequest.dart';
import 'package:rec/Pages/Public/Register/RegisterStepTwo.dart';
import 'package:rec/Pages/Public/ValidateSms/ValidateSms.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/routes.dart';

class RegisterOne extends StatefulWidget {
  @override
  RegisterOneState createState() => RegisterOneState();
}

class RegisterOneState extends State<RegisterOne> {
  RegisterData registerData = RegisterData(
    prefix: '+34',
    accountType: Account.TYPE_PRIVATE,
  );

  final _formKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<RegisterStepOneFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _header(),
      body: _body(),
    );
  }

  Widget _header() {
    var localizations = AppLocalizations.of(context);
    return PreferredSize(
      preferredSize: Size.fromHeight(170.0),
      child: AppBar(
        elevation: 0,
        backgroundColor: registerData.isAccountPrivate
            ? Brand.backgroundPrivateColor
            : Brand.backgroundCompanyColor,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(180),
          child: Container(
            height: 120,
            padding: EdgeInsets.only(left: 24, right: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      IconButton(
                        icon: registerData.isAccountPrivate
                            ? Image.asset('assets/avatar.png')
                            : Image.asset('assets/avatar-bw.png'),
                        onPressed: () =>
                            _registerFormKey.currentState.setToPrivate(),
                        iconSize: 60,
                      ),
                      SizedBox(height: 8),
                      Text(
                        localizations.translate('PARTICULAR'),
                        style: TextStyle(
                          color: registerData.isAccountPrivate
                              ? Colors.black
                              : Colors.grey,
                          fontSize: 12,
                          fontWeight: registerData.isAccountPrivate
                              ? FontWeight.w500
                              : FontWeight.w300,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      IconButton(
                        icon: registerData.isAccountPrivate
                            ? Image.asset('assets/organization-bw.png')
                            : Image.asset('assets/organization.png'),
                        onPressed: () =>
                            _registerFormKey.currentState.setToCompany(),
                        iconSize: 60,
                      ),
                      SizedBox(height: 8),
                      Text(
                        localizations.translate('ORGANIZATION'),
                        style: TextStyle(
                          color: registerData.isAccountPrivate
                              ? Colors.grey
                              : Colors.black,
                          fontSize: 12,
                          fontWeight: registerData.isAccountCompany
                              ? FontWeight.w500
                              : FontWeight.w300,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: Paddings.page,
        child: Column(
          children: [
            _preTitle(),
            _title(),
            RegisterStepOneForm(
              key: _registerFormKey,
              formKey: _formKey,
              onChange: (data) {
                setState(() => registerData = data);
              },
            ),
            _pressNextToAdd(),
            _termsAndServices(),
            _registerButton(),
          ],
        ),
      ),
    );
  }

  Widget _preTitle() {
    var localizations = AppLocalizations.of(context);
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        registerData.isAccountPrivate
            ? localizations.translate('PROMOTE_TRADE')
            : localizations.translate('TO_START_WRITE'),
        style: TextStyle(color: Brand.grayDark2, fontSize: 12),
      ),
    );
  }

  Widget _title() {
    var localizations = AppLocalizations.of(context);
    return Container(
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              localizations.translate('CREATE_USER'),
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          InfoTooltip.accent(
            message: localizations.translate('INTRODUCE_INFO'),
            child: Container(
              height: 40,
              alignment: Alignment.centerLeft,
              child: registerData.isAccountPrivate
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Icon(
                        Icons.help_outline,
                        color: Brand.accentColor,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _registerButton() {
    var localizations = AppLocalizations.of(context);

    return RecActionButton(
      label: registerData.isAccountPrivate
          ? localizations.translate('REGISTER')
          : localizations.translate('NEXT'),
      onPressed: next,
      icon: Icons.arrow_forward_ios,
      backgroundColor: registerData.isAccountPrivate
          ? Brand.primaryColor
          : Brand.accentColor,
    );
  }

  Widget _termsAndServices() {
    var localizations = AppLocalizations.of(context);
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Checkbox(
              value: registerData.termsAccepted,
              onChanged: (value) => setState(
                () => registerData.termsAccepted = value,
              ),
            ),
          ),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: localizations.translate('ACORD_WHIT_TEMS'),
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pressNextToAdd() {
    var localizations = AppLocalizations.of(context);
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(0, 32, 0, 16),
      child: Text(
        registerData.isAccountPrivate
            ? ''
            : localizations.translate('PRESS_NEXT_TO_ADD'),
        style: TextStyle(color: Brand.accentColor, fontSize: 14),
      ),
    );
  }

  void next() async {
    var localization = AppLocalizations.of(context);
    if (!_formKey.currentState.validate()) return;

    if (!registerData.termsAccepted) {
      RecToast.showError(
        context,
        localization.translate('NO_ACORD_TERMS'),
      );
      return;
    }

    // If TYPE_COMPANY redirect to second step
    if (registerData.isAccountCompany) {
      var newData = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => RegisterTwo(registerData: registerData),
        ),
      );

      if (newData != null) {
        registerData = newData;
        _formKey.currentState.validate();
      }
      return;
    }

    // Otherwise we can attempt register here
    _attemptPrivateRegister();
  }

  void _attemptPrivateRegister() {
    var localizations = AppLocalizations.of(context);

    RegisterRequest.tryRegister(context, registerData).then((result) async {
      if (result != null && !result.error) {
        var validateSMSResult = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => ValidateSms(
              registerData.phone,
              registerData.dni,
            ),
          ),
        );
        if (validateSMSResult != null && validateSMSResult['valid']) {
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.login));
        }
        return Future.value();
      }

      if (result.message.contains('Server Error')) {
        return RecToast.showError(
          context,
          localizations.translate('UNEXPECTED_SERVER_ERROR'),
        );
      }

      var translatedMessage = localizations.translate(result.message);
      if (translatedMessage != result.message) {
        // Hacky, this is to show API errors as a TextFormField hint
        // If error is set, validator will showp that error, see how it's setup in the form
        String fieldName = result.message.split(' ').first;
        registerData.addError(
            fieldName, localizations.translate(result.message));
        _formKey.currentState.validate();
      } else {
        RecToast.showError(
          context,
          localizations.translate(translatedMessage),
        );
      }
    }).catchError((e) {
      print(e);
    });
  }
}
