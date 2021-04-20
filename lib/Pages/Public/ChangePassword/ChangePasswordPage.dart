import 'package:flutter/material.dart';
import 'package:rec/Api/Services/ChangePasswordService.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Components/RecActionButton.dart';
import 'package:rec/Components/RecTextField.dart';

import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/brand.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage();

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  String password = '';
  String repassword = '';
  final _formKey = GlobalKey<FormState>();
  ChangePasswordService changePasswordService = ChangePasswordService();

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    String sms = ModalRoute.of(context).settings.arguments;
    var storage = RecStorage();

    // ignore: unused_element
    void changePassword() {
      if (_formKey.currentState.validate()) {
        storage.read(key: 'token').then((value) {
          changePasswordService.changePassword(
            accesToken: value,
            password: password,
            repassword: repassword,
            code: sms,
          );
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: Text(
                  localizations.translate('SEND_SMS_U'),
                  style: TextStyles.pageTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: Text(
                  localizations.translate('IPUT_NEW_PASSWORD'),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      child: RecTextField(
                        initialValue: password,
                        isNumeric: false,
                        keyboardType: TextInputType.text,
                        needObscureText: true,
                        placeholder: localizations.translate('NEW_PASSWORD'),
                        isPassword: false,
                        onChange: setPassword,
                        colorLine: Brand.primaryColor,
                        validator: (String password) {
                          if (password == repassword) {
                            return null;
                          } else {
                            return localizations.translate('NOT_SAME_PASSWORD');
                          }
                        },
                        isPhone: false,
                        icon: Icon(Icons.lock),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
                      child: RecTextField(
                        initialValue: password,
                        isNumeric: false,
                        keyboardType: TextInputType.text,
                        needObscureText: true,
                        placeholder:
                            localizations.translate('REPEAT_NEW_PASSWORD'),
                        isPassword: false,
                        onChange: setRePassword,
                        colorLine: Brand.primaryColor,
                        validator: (String rePassword) {
                          if (rePassword == password) {
                            return null;
                          } else {
                            return localizations.translate('NOT_SAME_PASSWORD');
                          }
                        },
                        isPhone: false,
                        icon: Icon(Icons.lock),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
                icon: Icons.arrow_forward_ios,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setPassword(String password) {
    this.password = password;
  }

  void setRePassword(String rePassword) {
    repassword = rePassword;
  }
}
