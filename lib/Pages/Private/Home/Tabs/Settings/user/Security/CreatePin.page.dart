import 'package:flutter/material.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/Pages/Private/Shared/CreatePin.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/config/routes.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class CreatePinPage extends StatefulWidget {
  @override
  _CreatePinPageState createState() => _CreatePinPageState();
}

class _CreatePinPageState extends State<CreatePinPage> {
  ChangePinData data = ChangePinData();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: EmptyAppBar(context),
        body: SingleChildScrollView(
          child: CreatePinWidget(
            label: 'CREATE_PIN_SHORT',
            buttonWithArrow: false,
            ifPin: (String pin) {
              var userState = UserState.of(context, listen: false);
              userState.setUser(userState.user!..hasPin = true);

              RecToast.showSuccess(context, 'CREATED_PIN_OK');
              Navigator.of(context).pushReplacementNamed(Routes.home);
            },
          ),
        ),
      ),
    );
  }
}
