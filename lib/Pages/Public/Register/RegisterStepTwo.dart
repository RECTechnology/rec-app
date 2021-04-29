import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/Components/Forms/RegisterStepTwo.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Text/CaptionText.dart';
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
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _header() {
    var localizations = AppLocalizations.of(context);
    var background = registerData.isAccountPrivate
        ? Brand.backgroundPrivateColor
        : Brand.backgroundCompanyColor;

    return PreferredSize(
      preferredSize: Size.fromHeight(170),
      child: AppBar(
        backgroundColor: background,
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
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Brand.grayDark,
                          fontWeight: FontWeight.w500,
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

  Widget _body() {
    var localizations = AppLocalizations.of(context);

    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: Padding(
        padding: Paddings.page,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
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
                Text(
                  localizations.translate('WHEN_INIT_SESION'),
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: Brand.accentColor),
                ),
              ],
            ),
            RecActionButton(
              onPressed: register,
              backgroundColor: Brand.accentColor,
              icon: Icons.arrow_forward_ios,
              label: localizations.translate('REGISTER'),
            )
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

    RegisterRequest.tryRegister(context, registerData).then((result) {
      if (result == null || !result.error) return;
      if (result.message.contains('Server Error')) {
        return _showError('UNEXPECTED_SERVER_ERROR');
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

      _showError(translatedMessage);
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
