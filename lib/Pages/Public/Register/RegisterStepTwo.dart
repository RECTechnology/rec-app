import 'package:flutter/material.dart';
import 'package:rec/Components/Forms/RegisterStepTwo.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/account_type_header.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Text/TitleText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/Pages/Public/Register/RegisterRequest.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/styles/paddings.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class RegisterTwo extends StatefulWidget {
  final RegisterData registerData;

  const RegisterTwo({Key? key, required this.registerData}) : super(key: key);

  @override
  RegisterTwoState createState() => RegisterTwoState();
}

class RegisterTwoState extends State<RegisterTwo> {
  final _formKey = GlobalKey<FormState>();
  RegisterData? registerData;

  @override
  void initState() {
    super.initState();
    registerData = widget.registerData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _header() as PreferredSizeWidget?,
      body: _body(),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _header() {
    final recTheme = RecTheme.of(context);
    final background = registerData!.isAccountPrivate
        ? recTheme!.backgroundPrivateColor
        : recTheme!.backgroundCompanyColor;

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
    final recTheme = RecTheme.of(context);
  
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
                tooltipColor: recTheme!.accentColor,
              ),
              RegisterStepTwoForm(
                formKey: _formKey,
                registerData: registerData,
                onChange: (data) => setState(() => registerData = data),
              ),
              LocalizedText(
                'WHEN_INIT_SESION',
                style: Theme.of(context).textTheme.caption!.copyWith(color: recTheme.accentColor),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: RecActionButton(
                  onPressed: register,
                  backgroundColor: recTheme.accentColor,
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
    if (!_formKey.currentState!.validate()) return;
    _attemptRegister();
  }

  void _attemptRegister() {
    var localizations = AppLocalizations.of(context);

    RegisterRequest.tryRegister(context, registerData).then((result) {
      if (result == null || !result.error) return;
      if (result.message.contains('Server Error')) {
        return _showError('UNEXPECTED_SERVER_ERROR');
      }

      var translatedMessage = localizations!.translate(result.message);
      if (translatedMessage != result.message) {
        String? fieldName = result.message.split(' ').first.toLowerCase();
        registerData!.addError(
          fieldName,
          localizations.translate(result.message),
        );
        _formKey.currentState!.validate();
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
    RecToast.showError(context, 'UNEXPECTED_SERVER_ERROR');
  }
}
