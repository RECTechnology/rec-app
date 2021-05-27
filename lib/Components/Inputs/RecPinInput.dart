import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:rec/brand.dart';

class RecPinInput extends StatefulWidget {
  final int fieldsCount;
  final void Function(String) onSaved;
  final void Function(String) onSubmit;
  final void Function(String) onChanged;

  final bool autofocus;

  RecPinInput({
    Key key,
    @required this.fieldsCount,
    this.onSaved,
    this.onSubmit,
    this.onChanged,
    this.autofocus = false,
  }) : super(key: key);

  @override
  _RecPinInputState createState() => _RecPinInputState();
}

class _RecPinInputState extends State<RecPinInput> {
  final TextEditingController _pinPutController = TextEditingController();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(6.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PinPut(
      autofocus: widget.autofocus,
      fieldsCount: widget.fieldsCount,
      controller: _pinPutController,
      selectedFieldDecoration: _pinPutDecoration.copyWith(
        border: Border.all(
          color: Brand.primaryColor.withOpacity(.5),
          width: 2,
        ),
      ),
      followingFieldDecoration: _pinPutDecoration.copyWith(
        border: Border.all(
          color: Colors.black.withOpacity(.5),
        ),
      ),
      submittedFieldDecoration: _pinPutDecoration,
      disabledDecoration: _pinPutDecoration.copyWith(
        border: Border.all(
          color: Colors.purple.withOpacity(.5),
        ),
      ),
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      onSubmit: widget.onSubmit,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
    );
  }
}
