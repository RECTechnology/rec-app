import 'package:flutter/material.dart';
import 'package:rec/Components/Forms/RegisterStepTwo.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/AccountTypeHeader.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Text/TitleText.dart';
import 'package:rec/Entities/Forms/RegisterData.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Public/Register/RegisterRequest.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';

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
    return Scaffold(
      appBar: _header(),
      body: _body(),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _header() {
    var background = registerData.isAccountPrivate ? Brand.backgroundPrivateColor : Brand.backgroundCompanyColor;

    return AppBar(
      backgroundColor: background,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(registerData),
      ),
      bottom: AccountTypeHeader(
        isPrivate: false,
        hidePrivate: true,
        onChanged: (_) {},
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: Paddings.page,
          child: Column(
            children: [
              CaptionText('MAKE_KNOW'),
              TitleText(
                'ADD_ORG',
                showTooltip: false,
                tooltipText: 'INTRODUCE_INFO',
                tooltipColor: Brand.accentColor,
              ),
              RegisterStepTwoForm(
                formKey: _formKey,
                registerData: registerData,
                onChange: (data) => setState(() => registerData = data),
              ),
              LocalizedText(
                'WHEN_INIT_SESION',
                style: Theme.of(context).textTheme.caption.copyWith(color: Brand.accentColor),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: RecActionButton(
                  onPressed: register,
                  backgroundColor: Brand.accentColor,
                  icon: Icons.arrow_forward_ios,
                  label: 'REGISTER',
                ),
              )
            ],
          ),
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

    RegisterRequest.tryRegister(context, registerData).then((result) {
      if (result == null || !result.error) return;
      if (result.message.contains('Server Error')) {
        return _showError('UNEXPECTED_SERVER_ERROR');
      }

      var translatedMessage = localizations.translate(result.message);
      if (translatedMessage != result.message) {
        String fieldName = result.message.split(' ').first.toLowerCase();
        registerData.addError(
          fieldName,
          localizations.translate(result.message),
        );
        _formKey.currentState.validate();
        setState(() {});

        // If error is not a field from this page, go back
        if (!['cif', 'name'].contains(fieldName)) {
          Navigator.of(context).pop(registerData);
        }
      } else {
        _showError(translatedMessage);
      }
    });
  }

  void _showError(String message) {
    var localizations = AppLocalizations.of(context);
    RecToast.showError(
      context,
      localizations.translate('UNEXPECTED_SERVER_ERROR'),
    );
  }
}
