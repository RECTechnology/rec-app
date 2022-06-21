import 'package:flutter/material.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Pages/Private/Shared/CreatePin.dart';
import 'package:rec/Pages/Private/Shared/EnterPin.page.dart';
import 'package:rec/providers/user_state.dart';

/// This widget renders either [EnterPin] or [CreatePin], if user has pin or not.
class RequestPin extends StatefulWidget {
  final Function(String pin) ifPin;
  final String? buttonContent;
  final bool buttonWithArrow;

  /// Whether this requests requires pin to be entered if not created
  final bool requiresEnteringPin;

  const RequestPin({
    Key? key,
    required this.ifPin,
    this.buttonContent,
    this.buttonWithArrow = true,
    this.requiresEnteringPin = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RequestPin();
}

class _RequestPin extends State<RequestPin> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context, listen: false);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: EmptyAppBar(context, backArrow: widget.buttonWithArrow),
        body: SingleChildScrollView(
          child: userState.user!.hasPin!
              ? EnterPin(
                  ifPin: widget.ifPin,
                  buttonContent: widget.buttonContent,
                  buttonWithArrow: widget.buttonWithArrow,
                )
              : CreatePinWidget(
                  ifPin: widget.ifPin,
                  buttonContent: widget.buttonContent,
                  buttonWithArrow: widget.buttonWithArrow,
                ),
        ),
      ),
    );
  }
}
