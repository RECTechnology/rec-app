import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/DniTextField.dart';
import 'package:rec/Components/Inputs/PrefixPhoneField.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Helpers/Validators.dart';
import 'package:rec/Pages/Public/SetPassword/SetPassword.dart';
import 'package:rec/Pages/Public/ValidateSms/ValidateSms.dart';

import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class ForgotPassword extends StatefulWidget {
  final String dni;
  final bool isChangePassword;

  ForgotPassword({
    this.dni = '',
    this.isChangePassword = false,
  });

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  String prefix = '+34';
  String phone = '';
  String dni;

  @override
  void initState() {
    super.initState();
    dni = widget.dni;
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: Paddings.page,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topTexts(),
                SizedBox(height: 32),
                forgotPasswordForm(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 24,
              left: 32,
              right: 32,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RecActionButton(
                label: localizations.translate('NEXT'),
                backgroundColor: Brand.primaryColor,
                icon: Icons.arrow_forward_ios_sharp,
                onPressed: sendSMS,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget topTexts() {
    var localizations = AppLocalizations.of(context);
    return Column(
      children: [
        Text(
          widget.isChangePassword
              ? localizations.translate('FORGOT_PASSWORD')
              : localizations.translate('VALIDATE_PHOME'),
          style: TextStyles.pageTitle,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 16),
        Text(
          widget.isChangePassword
              ? localizations.translate('ITRODUCE_DNI_TELF')
              : localizations.translate('INTRODUCE_DOCUMENT_AND_PHONE'),
          style: TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Widget forgotPasswordForm() {
    return Padding(
      padding: EdgeInsets.only(top: 40),
      child: Form(
        key: _formKey,
        child: Container(
            child: Column(
          children: [
            DniTextField(
              color: Colors.blueAccent,
              onChange: setDocument,
              initialValue: widget.isChangePassword ? null : widget.dni,
              validator: Validators.verifyIdentityDocument,
            ),
            PrefixPhoneField(
              prefix: prefix,
              phone: phone,
              prefixChange: setPrefix,
              phoneChange: setPhone,
              phoneValidator: Validators.phoneVerification,
            ),
          ],
        )),
      ),
    );
  }

  Future<void> sendSMS() async {
    var fullPhone = prefix + phone;
    var validateSMSResult = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => ValidateSms(
          fullPhone,
          dni,
        ),
      ),
    );
    if (validateSMSResult != null && validateSMSResult['valid']) {
      widget.isChangePassword
          ? Navigator.of(context).push(MaterialPageRoute(
              builder: (c) => SetPasswordPage(validateSMSResult['sms'])))
          : Navigator.of(context).popUntil(ModalRoute.withName(Routes.login));
    }
    return Future.value();
  }

  void setPhone(String phone) {
    this.phone = phone;
  }

  void setPrefix(String prefix) {
    this.prefix = prefix;
  }

  void setDocument(String dni) {
    this.dni = dni;
  }
}
