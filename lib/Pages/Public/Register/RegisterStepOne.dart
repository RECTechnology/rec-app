import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:rec/Components/IconButton.dart';
import 'package:rec/Components/RecTextField.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Verify/VerifyDataRec.dart';
import 'package:rec/brand.dart';

class RegisterOne extends StatefulWidget {
  @override
  RegisterOneState createState() => RegisterOneState();
}

class RegisterOneState extends GenericRecViewScreen<RegisterOne> {
  bool checkValue = false;

  String prefix = '+34';
  String telephone = '';
  String idDocument = '';
  String password = '';
  String accountType;

  Map<String, String> data;

  final _formKey = GlobalKey<FormState>();

  bool get isAccountPrivate => accountType == Account.TYPE_PRIVATE;

  @override
  Widget buildPageContent(
    BuildContext context,
    AppState state,
    UserState userState,
    AppLocalizations localizations,
  ) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(174.0),
        child: AppBar(
          backgroundColor: isAccountPrivate
              ? Brand.backgroundPrivateColor
              : Brand.backgroundCompanyColor,
          leading: IconButtonRec(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          bottom: PreferredSize(
            preferredSize: Size(100, 70),
            child: Container(
              child: Row(
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    margin: EdgeInsets.fromLTRB(82, 0, 86, 25),
                    child: Column(
                      children: [
                        IconButton(
                          icon: isAccountPrivate
                              ? Image.asset('assets/avatar.png')
                              : Image.asset('assets/avatar-bw.png'),
                          onPressed: setToParticular,
                        ),
                        Text(
                          "Private",
                          style: TextStyle(
                              color:
                                  isAccountPrivate ? Colors.black : Colors.grey,
                              fontSize: 12),
                        )
                      ],
                    ),
                  ),
                  Container(
                      width: 75,
                      height: 75,
                      margin: EdgeInsets.fromLTRB(0, 0, 70, 25),
                      child: Column(
                        children: [
                          IconButton(
                            icon: isAccountPrivate
                                ? Image.asset('assets/organization-bw.png')
                                : Image.asset('assets/organization.png'),
                            onPressed: setToOrganizations,
                          ),
                          Text(
                            "Organization",
                            style: TextStyle(
                                color: isAccountPrivate
                                    ? Colors.grey
                                    : Colors.black,
                                fontSize: 12),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text(
                isAccountPrivate
                    ? localizations.translate('PROMOTE_TRADE')
                    : localizations.translate('TO_START_WRITE'),
                style: TextStyle(color: Colors.black, fontSize: 10),
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: localizations.translate('CREATE_USER'),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: isAccountPrivate
                        ? null
                        : IconButtonRec(
                            icon: Icon(
                              Icons.announcement_outlined,
                              color: Colors.deepOrange,
                            ),
                            onPressed: () {
                              printToastRec(
                                localizations.translate('INTRODUCE_INFO'),
                              );
                            },
                          ),
                  )
                ],
              ),
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                text: localizations.translate('TELF'),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 38),
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
                                  colorLine: isAccountPrivate
                                      ? Colors.blueAccent
                                      : Colors.orange,
                                  function: setPhone,
                                  isPhone: false,
                                  validator: VerifyDataRec.phoneVerification,
                                ),
                              ),
                            ],
                          ),
                        ],
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
                        icon: Icon(Icons.person),
                        colorLine: isAccountPrivate
                            ? Colors.blueAccent
                            : Colors.orange,
                        function: setIdDocument,
                        validator: VerifyDataRec.verifyIdentityDocument,
                        isPhone: false,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: RecTextField(
                        placeholder: localizations.translate('PASSWORD'),
                        needObscureText: true,
                        keyboardType: TextInputType.text,
                        isPassword: false,
                        isNumeric: false,
                        icon: Icon(Icons.lock),
                        colorLine: isAccountPrivate
                            ? Colors.blueAccent
                            : Colors.orange,
                        function: setPassword,
                        isPhone: false,
                        validator: VerifyDataRec.verifyPassword,
                      ),
                    ),
                  ],
                )),
            isAccountPrivate
                ? Text('')
                : Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: Text(
                      localizations.translate('PRESS_NEXT_TO_ADD'),
                      style: TextStyle(color: Colors.deepOrange, fontSize: 14),
                    ),
                  ),
            Container(
              child: isAccountPrivate ? const SizedBox(height: 20) : null,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Row(
                children: [
                  Checkbox(
                    value: checkValue,
                    onChanged: (bool value) {
                      setState(() {
                        checkValue = value;
                      });
                    },
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
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ButtonRec(
                textColor: Colors.white,
                backgroundColor:
                    isAccountPrivate ? Colors.blueAccent : Colors.deepOrange,
                onPressed: next,
                isButtonDisabled: false,
                widget: Icon(Icons.arrow_forward_ios),
                text: isAccountPrivate
                    ? localizations.translate('REGISTER')
                    : localizations.translate('NEXT'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void setToParticular() {
    setAccountType(Account.TYPE_PRIVATE);
  }

  void setToOrganizations() {
    setAccountType(Account.TYPE_COMPANY);
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

  void setPassword(String password) {
    this.password = password;
  }

  void next() {
    var localization = AppLocalizations.of(context);
    if (!_formKey.currentState.validate()) return;

    if (checkValue && isAccountPrivate != true) {
      Navigator.of(context).pushNamed('/registerTwo', arguments: data);
    } else {
      printToastRec(localization.translate("NO_ACORD_TERMS"));
    }
  }

  void printToastRec(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg.toString()),
        duration: const Duration(milliseconds: 2000),
        width: 300.0,
        // Width of the SnackBar.
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0, // Inner padding for SnackBar content.
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  void setAccountType(String type) {
    setState(() {
      accountType = type;
    });
  }
}
