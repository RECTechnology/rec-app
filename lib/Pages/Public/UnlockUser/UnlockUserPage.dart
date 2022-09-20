import 'package:flutter/material.dart';
import 'package:rec/Components/Forms/UnlockUserForm.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Layout/FormPageLayout.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Text/TitleText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/Pages/Public/Login/Login.page.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

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

  final String? sms;

  UnlockUserPage({this.sms = ''});

  @override
  _UnlockUserPageState createState() => _UnlockUserPageState();
}

class _UnlockUserPageState extends State<UnlockUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UnlockUserService(env: env);
  late UnlockUserData data;

  @override
  void initState() {
    super.initState();
    data = UnlockUserData(sms: widget.sms);
  }

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
   
    return FormPageLayout(
      appBar: EmptyAppBar(context),
      form: _unlockUserForm(),
      header: _topTexts(),
      submitButton: RecActionButton(
        label: 'UNLOCK',
        backgroundColor: recTheme?.primaryColor,
        onPressed: () => _next(),
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
        if (data != null) this.data = data;
      },
    );
  }

  void _next() async {
    if (!_formKey.currentState!.validate()) return;

    await Loading.show();
    await _userService.unlockUser(data).then(_unlockUserOk).onError(_unlockUserError);
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
