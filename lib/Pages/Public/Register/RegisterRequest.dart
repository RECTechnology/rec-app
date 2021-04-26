import 'package:flutter/material.dart';
import 'package:rec/Api/Services/RegisterService.dart';
import 'package:rec/Components/Indicators/LoadingIndicator.dart';
import 'package:rec/Entities/Forms/RegisterData.dart';
import 'package:rec/Pages/Public/Register/RegisterRequestResult.dart';

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

  @override
  void initState() {
    super.initState();

    registerService.register(widget.data).then(
      (value) {
        Navigator.of(context).pop(
          RegisterRequestResult(
            error: false,
            message: null,
          ),
        );
      },
    ).catchError(
      (e) {
        Navigator.of(context).pop(
          RegisterRequestResult(
            error: true,
            message: e['body']['message'],
          ),
        );
      },
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
