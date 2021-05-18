import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rec/Api/Services/PhoneVerificationService.dart';
import 'package:rec/Api/Services/RegisterService.dart';
import 'package:rec/Api/Services/SMSService.dart';
import 'package:rec/Components/Indicators/LoadingIndicator.dart';
import 'package:rec/Entities/Forms/RegisterData.dart';
import 'package:rec/Entities/User.ent.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Public/Register/RegisterRequestResult.dart';
import 'package:rec/Pages/Public/SmsCode/SmsCode.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/routes.dart';

class RegisterRequest extends StatefulWidget {
  final RegisterData data;

  const RegisterRequest({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterRequest();
  }

  static Future tryRegister(BuildContext context, RegisterData data) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: RegisterRequest(data: data),
      ),
    );
  }
}

class _RegisterRequest extends State<RegisterRequest> {
  RegisterService registerService = RegisterService();
  final validateSMS = PhoneVerificationService();
  final smsService = SMSService();

  @override
  void initState() {
    super.initState();

    registerService.register(widget.data).then(
      (value) async {
        await _sendSmsCode(widget.data.phone, widget.data.dni);
        await _goToEnterSmsCode();
        Navigator.of(context).popUntil(ModalRoute.withName(Routes.login));
      },
    ).catchError(
      (error) {
        Navigator.of(context).pop(
          RegisterRequestResult(
            error: true,
            message: error.message,
          ),
        );
      },
    );
  }

  Future<void> _sendSmsCode(String phone, String dni) {
    return smsService
        .sendValidatePhoneSms(
          phone: widget.data.phone,
          prefix: widget.data.prefix,
        )
        .catchError(_onError);
  }

  Future<void> _goToEnterSmsCode() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => SmsCode(
          phone: widget.data.phone,
          dni: widget.data.dni,
          onCode: _validateSmsCode,
          prefix: widget.data.prefix,
        ),
      ),
    );
  }

  void _validateSmsCode(String smsCode) {
    EasyLoading.show();
    validateSMS
        .validatePhone(
          smscode: smsCode,
          dni: widget.data.dni,
          prefix: widget.data.prefix,
          phone: widget.data.phone,
        )
        .then(_validateOk)
        .catchError(_onError);
  }

  void _validateOk(value) {
    var userState = UserState.of(context, listen: false);
    userState.setSavedUser(User(username: widget.data.dni));

    Navigator.of(context).popUntil(ModalRoute.withName(Routes.login));
    RecToast.showSuccess(context, 'REGISTERED_OK');
    EasyLoading.dismiss();
  }

  void _onError(error) {
    var localizations = AppLocalizations.of(context);
    EasyLoading.dismiss();
    RecToast.showError(
      context,
      localizations.translate(error.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: LoadingIndicator(),
      ),
    );
  }
}
