import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/Components/RecActionButton.dart';
import 'package:rec/Components/RecTextField.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/Helpers/VerifyDataRec.dart';
import 'package:rec/brand.dart';

class RegisterTwo extends StatefulWidget {
  @override
  RegisterTwoState createState() => RegisterTwoState();
}

class RegisterTwoState extends State<RegisterTwo> {
  String userName = '';
  String CIF = '';
  String email = '';

  final _formKey = GlobalKey<FormState>();

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
      preferredSize: Size.fromHeight(170),
      child: AppBar(
        backgroundColor: Brand.backgroundCompanyColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(140),
          child: Container(
            height: 100,
            child: Center(
              child: Column(
                children: [
                  IconButton(
                    icon: Image.asset('assets/organization.png'),
                    iconSize: 40,
                    onPressed: () {},
                  ),
                  Text(
                    localizations.translate('ORGANIZATION'),
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    var localizations = AppLocalizations.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: Paddings.page,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                localizations.translate('MAKE_KNOW'),
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: localizations.translate('ADD_ORG'),
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 40, bottom: 16),
                    child: RecTextField(
                      needObscureText: false,
                      placeholder: localizations.translate('NAME'),
                      keyboardType: TextInputType.text,
                      isPassword: false,
                      isNumeric: false,
                      label: localizations.translate('NAME'),
                      colorLine: Colors.orange,
                      icon: Icon(
                        Icons.business_center,
                        color: Brand.grayIcon,
                      ),
                      onChange: setUserName,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40, bottom: 16),
                    child: RecTextField(
                      label: localizations.translate('CIF'),
                      placeholder: localizations.translate('CIF'),
                      needObscureText: false,
                      keyboardType: TextInputType.text,
                      isPassword: false,
                      isNumeric: false,
                      colorLine: Colors.orange,
                      onChange: setCIF,
                      icon: Icon(
                        Icons.work_outlined,
                        color: Brand.grayIcon,
                      ),
                      validator: VerifyDataRec.validateCif,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 84),
            Text(
              localizations.translate('WHEN_INIT_SESION'),
              style: TextStyle(color: Colors.deepOrange, fontSize: 12),
            ),
            RecActionButton(
              onPressed: register,
              backgroundColor: Colors.deepOrange,
              icon: Icons.arrow_forward_ios,
              label: localizations.translate('REGISTER'),
            ),
          ],
        ),
      ),
    );
  }

  void setUserName(String userName) {
    setState(() => this.userName = userName);
  }

  void setEmail(String email) {
    setState(() => this.email = email);
  }

  void setCIF(String CIF) {
    setState(() => this.CIF = CIF);
  }

  void register() {
    if (_formKey.currentState.validate()) {
      print('Registring...');
    } else {
      print('Bad Cif');
    }
  }
}
