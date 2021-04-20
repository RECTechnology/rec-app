import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Api/Services/SMSService.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:rec/Components/RecTextField.dart';

import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Helpers/VerifyDataRec.dart';
import 'package:rec/brand.dart';

class RecoveryPasswordPage extends StatefulWidget {
  @override
  _RecoveryPasswordPageState createState() => _RecoveryPasswordPageState();
}

class _RecoveryPasswordPageState extends State<RecoveryPasswordPage> {
  SMSService smsService = SMSService();
  String idDocument = '';
  String phone = '649516729';
  String prefix = '+34';
  final _formKey = GlobalKey<FormState>();

  void goNext() {
    Auth.getAppToken().then((value) {
      if (!_formKey.currentState.validate()) return;

      smsService.sendSMS(
        dni: idDocument,
        phone: '$prefix $phone',
        accesToken: value,
      );

      Navigator.of(context).pushNamed(
        '/sendSMS',
        arguments: {
          'phone': phone,
          'isChangePassword': 'no',
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.fromLTRB(33, 20, 32, 0),
                child: Center(
                  child: Text(
                    localizations.translate('FORGOT_PASSWORD'),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.right,
                  ),
                )),
            Container(
                margin: EdgeInsets.fromLTRB(33, 20, 32, 38),
                child: Center(
                  child: Text(
                    localizations.translate('ITRODUCE_DNI_TELF'),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.left,
                  ),
                )),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(35, 0, 35, 14),
                      child: RecTextField(
                        isNumeric: false,
                        keyboardType: TextInputType.text,
                        needObscureText: false,
                        placeholder: localizations.translate('WRITE_DOCUMENT'),
                        label: localizations.translate('DNI'),
                        isPassword: false,
                        onChange: setDni,
                        colorLine: Brand.primaryColor,
                        validator: VerifyDataRec.verifyIdentityDocument,
                        isPhone: false,
                        icon: Icon(
                          Icons.person,
                          color: Brand.defectText,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(26, 0, 35, 0),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
                                child: RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    text: localizations.translate('TELF'),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 8, 50),
                                child: CountryCodePicker(
                                  onChanged: setPrefix,
                                  initialSelection: 'ES',
                                  favorite: ['+34', 'ES'],
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: false,
                                  alignLeft: false,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            height: 115,
                            width: 252,
                            child: RecTextField(
                              needObscureText: false,
                              keyboardType: TextInputType.phone,
                              isPassword: false,
                              isNumeric: true,
                              validator: VerifyDataRec.phoneVerification,
                              icon: Icon(
                                Icons.phone,
                                color: Brand.defectText,
                              ),
                              colorLine: Colors.blueAccent,
                              onChange: setPhone,
                              isPhone: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            Container(
                margin: EdgeInsets.fromLTRB(20, 180, 20, 0),
                //Left,Top,Right,Bottom
                //Left,Top,Right,Bottom
                child: ButtonRec(
                  textColor: Colors.white,
                  backgroundColor: Colors.blue,
                  onPressed: goNext,
                  widthBox: 370,
                  isButtonDisabled: false,
                  widget: Icon(Icons.arrow_forward_ios),
                  text: localizations.translate('NEXT'),
                )),
          ],
        ),
      ),
    );
  }

  void setDni(String idDocument) {
    this.idDocument = idDocument;
  }

  void setPhone(String phone) {
    this.phone = phone;
  }

  void setPrefix(CountryCode prefix) {
    this.prefix = prefix.toString();
  }
}
