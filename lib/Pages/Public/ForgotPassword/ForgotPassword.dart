import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/DniTextField.dart';
import 'package:rec/Components/Inputs/PrefixPhoneField.dart';
import 'package:rec/Components/RecActionButton.dart';
import 'package:rec/Helpers/VerifyDataRec.dart';

import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/routes.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword();

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String prefix = '+34';
  String phone = '';
  String dni = '';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.page,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.translate('FORGOT_PASSWORD'),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 16),
              Text(
                localizations.translate('ITRODUCE_DNI_TELF'),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 32),
              Container(
                child: DniTextField(
                  color: Colors.blueAccent,
                  onChange: setDocument,
                  validator: VerifyDataRec.verifyIdentityDocument,
                ),
              ),
              PrefixPhoneField(
                prefix: prefix,
                phone: phone,
                prefixChange: setPrefix,
                phoneChange: setPhone,
                phoneValidator: VerifyDataRec.phoneVerification,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: RecActionButton(
                  onPressed: changePassword,
                  label: localizations.translate('NEXT'),
                  icon: Icons.arrow_forward_ios,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  void changePassword() {
    Navigator.of(context).pushNamed(Routes.validateSms);
  }
}
