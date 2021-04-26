import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/Components/Forms/RegisterStepTwo.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Entities/Forms/RegisterData.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Public/Register/RegisterRequest.dart';
import 'package:rec/Pages/Public/ValidateSms/ValidateSms.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class RegisterTwo extends StatefulWidget {
  final RegisterData registerData;

  const RegisterTwo({Key key, @required this.registerData}) : super(key: key);


  @override
  RegisterTwoState createState() => RegisterTwoState();
}

class RegisterTwoState extends State<RegisterTwo> {
  final _formKey = GlobalKey<FormState>();

  RegisterData registerData;

  @override
  void initState() {
    super.initState();
    registerData = widget.registerData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _header(), body: _body());
  }

  Widget _header() {
    var localizations = AppLocalizations.of(context);
    return PreferredSize(
      preferredSize: Size.fromHeight(170),
      child: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(registerData),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(180),
          child: Container(
            height: 120,
            padding: EdgeInsets.only(left: 24, right: 24),
            child: Center(
              child: Column(
                children: [
                  IconButton(
                    icon: registerData.isAccountPrivate
                        ? Image.asset('assets/organization-bw.png')
                        : Image.asset('assets/organization.png'),
                    iconSize: 60,
                    onPressed: null,
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
          ),
        ),
      ),
    );
  }

  Widget _preTitle() {
    var localizations = AppLocalizations.of(context);
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        localizations.translate('MAKE_KNOW'),
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
              localizations.translate('ADD_ORG'),
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            height: 40,
            alignment: Alignment.centerLeft,
            child: null,
          )
        ],
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
            RegisterStepTwoForm(
              formKey: _formKey,
              registerData: registerData,
              onChange: (data) => setState(() => registerData = data),
            ),
            SizedBox(height: 84),
            Text(
              localizations.translate('WHEN_INIT_SESION'),
              style: TextStyle(color: Brand.accentColor, fontSize: 12),
            ),
            RecActionButton(
              onPressed: register,
              backgroundColor: Brand.accentColor,
              icon: Icons.arrow_forward_ios,
              label: localizations.translate('REGISTER'),
            ),
          ],
        ),
      ),
    );
  }

  void register() {
    if (!_formKey.currentState.validate()) return;

    _attemptRegister();
  }

  void _attemptRegister() {
    var localizations = AppLocalizations.of(context);

    RegisterRequest.tryRegister(context, registerData).then((result) async {
      if (!result.error) {
        var validateSMSResult = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => ValidateSms(registerData.phone, registerData.dni),
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
        String fieldName = result.message.split(' ').first;
        registerData.addError(
          fieldName,
          localizations.translate(result.message),
        );
        _formKey.currentState.validate();

        // If error is not a field from this page, go back
        if (!['cif', 'name'].contains(fieldName)) {
          Navigator.of(context).pop(registerData);
        }
      }

      RecToast.showError(
        context,
        localizations.translate(translatedMessage),
      );

    });
  }
}
