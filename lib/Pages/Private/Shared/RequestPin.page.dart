import 'package:flutter/material.dart';
import 'package:rec/Pages/Private/Shared/CreatePin.page.dart';
import 'package:rec/Pages/Private/Shared/EnterPin.page.dart';
import 'package:rec/Providers/UserState.dart';

/// This widget renders either [EnterPin] or [CreatePin], if user has pin or not.
class RequestPin extends StatefulWidget {
  final Function(String pin) ifPin;

  const RequestPin({
    Key key,
    @required this.ifPin,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RequestPin();
}

class _RequestPin extends State<RequestPin> {
  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context, listen: false);
    return userState.user.hasPin
        ? EnterPin(ifPin: widget.ifPin)
        : CreatePin(ifPin: widget.ifPin);
  }
}
