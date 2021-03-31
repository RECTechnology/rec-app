import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:rec/Components/IconButton.dart';
import 'package:rec/Components/RecTextField.dart';

import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Verify/VerifyDataRec.dart';

class SetPasswordPage extends StatefulWidget {
  SetPasswordPage();

  @override
  _SetPasswordPageState createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends GenericRecViewScreen<SetPasswordPage> {
  String newPassword = '+34';
  String confirmNewPassword = '';

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
            Icons.arrow_back ,
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
              margin: EdgeInsets.fromLTRB(32, 0, 50, 39),
              child: Text(
                localizations.translate('INTRODUCE_NEW_PASSWORD'),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: RecTextField(
                placeholder: localizations.translate('NEW_PASSWORD'),
                needObscureText: true,
                keyboardType: TextInputType.text,
                isPassword: false,
                isNumeric: false,
                icon: Icon(Icons.lock),
                colorLine:  Colors.blueAccent,
                function: setNewPassword,
                isPhone: false,
                validator: VerifyDataRec.verifyPassword,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: RecTextField(
                placeholder: localizations.translate('REPEAT_PASSWORD'),
                needObscureText: true,
                keyboardType: TextInputType.text,
                isPassword: false,
                isNumeric: false,
                icon: Icon(Icons.lock),
                colorLine:  Colors.blueAccent,
                function: setNewPassword,
                isPhone: false,
                validator: VerifyDataRec.verifyPassword,
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(0, 203, 0, 0),
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



  void setNewPassword(String newPassword) {
    this.newPassword = newPassword;
  }

  void setNewConfirmPassword(String confirmPassword) {
    this.confirmNewPassword = confirmPassword;
  }

  void changePassword() {}
}
