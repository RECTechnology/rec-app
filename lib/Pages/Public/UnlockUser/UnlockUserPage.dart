import 'package:flutter/material.dart';
import 'package:rec/Api/HandledErrors.dart';
import 'package:rec/Api/Services/public/UnlockUserService.dart';
import 'package:rec/Components/Forms/UnlockUserForm.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Text/TitleText.dart';
import 'package:rec/Entities/Forms/UnlockUserData.dart';
import 'package:rec/Environments/env.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Public/Login/Login.page.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';

class UnlockUserPage extends StatefulWidget {
  /// Handles onGenerateRoute,
  /// will be called if a generated route matches [Routes.unlockUserLink]
  static MaterialPageRoute handleRoute(RouteSettings settings, Env env) {
    var uri = '${env.DEEPLINK_URL}${settings.name}';
    var params = Uri.parse(uri).queryParameters;
    var sms = params['smscode'];

    return MaterialPageRoute(
      builder: (ctx) => UnlockUserPage(sms: sms),
    );
  }

  final String sms;

  UnlockUserPage({this.sms = ''});

  @override
  _UnlockUserPageState createState() => _UnlockUserPageState();
}

class _UnlockUserPageState extends State<UnlockUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UnlockUserService();
  UnlockUserData data;

  @override
  void initState() {
    super.initState();
    data = UnlockUserData(prefix: '+34', sms: widget.sms);
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: EmptyAppBar(context, backArrow: false, crossX: true),
        body: SingleChildScrollView(
          child: Padding(
            padding: Paddings.pageNoTop,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _topTexts(),
                _unlockUserForm(),
                SizedBox(height: 130),
                RecActionButton(
                  label: localizations.translate('UNLOCK'),
                  backgroundColor: Brand.primaryColor,
                  onPressed: () => _next(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topTexts() {
    return Column(
      children: [
        TitleText('UNLOCK_PASSWORD'),
        SizedBox(height: 16),
        CaptionText(
          'INTRODUCE_TO_UNLOCK',
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(height: 22),
      ],
    );
  }

  Widget _unlockUserForm() {
    return UnlockUserForm(
      formKey: _formKey,
      data: data,
      onChange: (data) {
        this.data = data;
      },
    );
  }

  void _next() async {
    if (!_formKey.currentState.validate()) return;

    await Loading.show();
    await _userService
        .unlockUser(data)
        .then(_unlockUserOk)
        .onError(_unlockUserError);
  }

  void _unlockUserOk(value) {
    Loading.dismiss();
    RecToast.showSuccess(
      context,
      'UNLOCK_USER_SUCCES',
    );

    if (Navigator.canPop(context)) {
      return Navigator.pop(context);
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(dni: data.dni),
      ),
    );
  }

  void _unlockUserError(error, stackTrace) {
    var errorMsg = error.message;

    if (error.message == 'Wrong phone' || error.message == 'Wrong DNI') {
      errorMsg = 'WRONG_PHONE_DNI';
    }
    if (error.message == HandledErrors.smsExpiredOrInvalid) {
      errorMsg = 'WRONG_SMS';
    }

    Loading.dismiss();
    RecToast.showError(context, errorMsg);
  }
}
