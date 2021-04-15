import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/Components/RecActionButton.dart';
import 'package:rec/Components/RecTextField.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/Helpers/VerifyDataRec.dart';
import 'package:rec/brand.dart';
import 'package:rec/Components/RecToast.dart';

class RegisterOne extends StatefulWidget {
  @override
  RegisterOneState createState() => RegisterOneState();
}

class RegisterOneState extends State<RegisterOne> {
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
        backgroundColor: isAccountPrivate
            ? Brand.backgroundPrivateColor
            : Brand.backgroundCompanyColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(140),
          child: Container(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      IconButton(
                        icon: isAccountPrivate
                            ? Image.asset('assets/avatar.png')
                            : Image.asset('assets/avatar-bw.png'),
                        onPressed: setToParticular,
                        iconSize: 50,
                      ),
                      Text(
                        localizations.translate('PARTICULAR'),
                        style: TextStyle(
                          color: isAccountPrivate ? Colors.black : Colors.grey,
                          fontSize: 12,
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
                        icon: isAccountPrivate
                            ? Image.asset('assets/organization-bw.png')
                            : Image.asset('assets/organization.png'),
                        onPressed: setToOrganizations,
                        iconSize: 50,
                      ),
                      Text(
                        localizations.translate('ORGANIZATION'),
                        style: TextStyle(
                          color: isAccountPrivate ? Colors.grey : Colors.black,
                          fontSize: 12,
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
    var localizations = AppLocalizations.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: Paddings.page,
        child: Column(
          children: [
            _preTitle(),
            _title(),
            _registerForm(),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 32, 0, 16),
              child: Text(
                isAccountPrivate
                    ? ''
                    : localizations.translate('PRESS_NEXT_TO_ADD'),
                style: TextStyle(color: Colors.deepOrange, fontSize: 14),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: _termsAndServices(),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: _registerButton(),
            )
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
        isAccountPrivate
            ? localizations.translate('PROMOTE_TRADE')
            : localizations.translate('TO_START_WRITE'),
        style: TextStyle(color: Colors.black, fontSize: 12),
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
          Container(
            height: 40,
            alignment: Alignment.centerLeft,
            child: isAccountPrivate
                ? null
                : IconButton(
                    icon: Icon(
                      Icons.announcement_outlined,
                      color: Colors.deepOrange,
                    ),
                    onPressed: () {
                      RecToast.show(
                        context,
                        localizations.translate('INTRODUCE_INFO'),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }

  Widget _registerButton() {
    var localizations = AppLocalizations.of(context);

    return RecActionButton(
      label: isAccountPrivate
          ? localizations.translate('REGISTER')
          : localizations.translate('NEXT'),
      onPressed: next,
      icon: Icons.arrow_forward_ios,
      backgroundColor:
          isAccountPrivate ? Brand.primaryColor : Colors.deepOrange,
    );
  }

  Widget _termsAndServices() {
    var localizations = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Checkbox(
            value: checkValue,
            onChanged: (bool value) {
              setState(() {
                checkValue = value;
              });
            },
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
    );
  }

  Widget _registerForm() {
    var localizations = AppLocalizations.of(context);
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    localizations.translate('TELEFONO'),
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 50,
                        child: CountryCodePicker(
                          onChanged: setPrefix,
                          initialSelection: 'ES',
                          favorite: ['+34', 'ES'],
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: RecTextField(
                        placeholder: localizations.translate('TELEFONO'),
                        keyboardType: TextInputType.phone,
                        icon: Icon(
                          Icons.phone,
                          color: Brand.grayIcon,
                        ),
                        colorLine: isAccountPrivate
                            ? Brand.primaryColor
                            : Colors.orange,
                        colorLabel: isAccountPrivate
                            ? Brand.primaryColor
                            : Colors.orange,
                        onChange: setPhone,
                        validator: VerifyDataRec.phoneVerification,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // dni
          RecTextField(
            label: localizations.translate('DNI/NIE'),
            placeholder: localizations.translate('DNI/NIE'),
            keyboardType: TextInputType.phone,
            icon: Icon(Icons.person, color: Brand.grayIcon),
            colorLine: isAccountPrivate ? Brand.primaryColor : Colors.orange,
            onChange: setIdDocument,
            validator: VerifyDataRec.verifyIdentityDocument,
          ),
          SizedBox(height: 16),
          // password
          RecTextField(
            label: localizations.translate('PASSWORD'),
            placeholder: localizations.translate('PASSWORD'),
            needObscureText: true,
            keyboardType: TextInputType.text,
            icon: Icon(Icons.lock, color: Brand.grayIcon),
            colorLine: isAccountPrivate ? Brand.primaryColor : Colors.orange,
            onChange: setPassword,
            validator: VerifyDataRec.verifyPassword,
          ),
        ],
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
    setState(() => this.telephone = telephone);
  }

  void setPrefix(CountryCode prefix) {
    setState(() => this.prefix = prefix.toString());
  }

  void setIdDocument(String idDocument) {
    setState(() => this.idDocument = idDocument);
  }

  void setPassword(String password) {
    setState(() => this.password = password);
  }

  void next() {
    var localization = AppLocalizations.of(context);
    if (!_formKey.currentState.validate()) return;

    if (checkValue && isAccountPrivate != true) {
      Navigator.of(context).pushNamed('/registerTwo', arguments: data);
    } else {
      RecToast.show(context, localization.translate('NO_ACORD_TERMS'));
    }
  }

  void setAccountType(String type) {
    _formKey?.currentState?.reset();
    setState(() {
      accountType = type;
    });
  }
}
