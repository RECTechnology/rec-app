import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:rec/Components/IconButton.dart';
import 'package:rec/Components/RecTextField.dart';

import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';

class RecoveryPassword extends StatefulWidget {
  RecoveryPassword();

  @override
  _RecoveryPasswordState createState() => _RecoveryPasswordState();
}

class _RecoveryPasswordState extends GenericRecViewScreen<RecoveryPassword> {
  String prefix = '+34';
  String telephone = '';
  String idDocument = '';

  @override
  Widget buildPageContent(
    BuildContext context,
    AppState state,
    AppLocalizations localizations,
  ) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButtonRec(
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
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(32, 20, 32, 20),
              child: Text(
                localizations.translate('FORGOT_PASSWORD'),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(32, 0, 50, 0),
              child: Text(
                localizations.translate('ITRODUCE_DNI_TELF'),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: RecTextField(
                placeholder: localizations.translate('DNI/NIE'),
                needObscureText: false,
                keyboardType: TextInputType.text,
                isPassword: false,
                isNumeric: false,
                icon: Icon(Icons.person,),
                colorLine: Colors.blueAccent,
                function: setIdDocument,
                isPhone: false,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: localizations.translate('TELF'),
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        child: CountryCodePicker(
                          onChanged: setPrefix,
                          initialSelection: 'ES',
                          favorite: ['+34', 'ES'],
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,

                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        height: 115,
                        width: 280,
                        child: RecTextField(
                          needObscureText: false,
                          keyboardType: TextInputType.phone,
                          isPassword: false,
                          isNumeric: true,
                          icon: Icon(Icons.phone),
                          colorLine: Colors.blueAccent,
                          function: setPhone,
                          isPhone: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 263, 0, 0),
              width: 296,
              height: 48,
              child: ButtonRec(
                textColor: Colors.white,
                backgroundColor: Colors.blue,
                onPressed: changePassword,
                widthBox: 370,
                isButtonDisabled: false,
                widget: Icon(Icons.arrow_forward_ios),
                text: localizations.translate('NEXT'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setPhone(String telephone) {
    this.telephone = telephone;
  }

  void setPrefix(CountryCode prefix) {
    this.prefix = prefix.toString();
  }

  void setIdDocument(String idDocument) {
    this.idDocument = idDocument;
  }

  void changePassword() {}
}
