import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:rec/brand.dart';

/// Renders a custom Pin Input
class RecPinInput extends StatefulWidget {
  /// Displayed fields count. PIN code length.
  final int fieldsCount;

  /// Called when RecInputPin is saved
  final void Function(String) onSaved;

  /// Called when RecInputPin is submitted
  final void Function(String) onSubmit;

  /// Called when the pin changes (ie: each time character is typed)
  final void Function(String) onChanged;

  /// Whether the RecInputPin should be focused by default
  final bool autofocus;

  final Pattern validator;

  RecPinInput({
    Key key,
    @required this.fieldsCount,
    this.onSaved,
    this.onSubmit,
    this.onChanged,
    this.autofocus = false,
    Pattern validator,
  })  : validator = validator ?? RegExp(r'[0-9]'),
        super(key: key);

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
    return GestureDetector(
      onLongPress: () async {
        var clipboardContent = (await Clipboard.getData('text/plain')).text;
        var matchesLength = clipboardContent.length == widget.fieldsCount;
        var onlyDigits = clipboardContent.contains(widget.validator);

        // If the clipboardContent does not fit the current pin format, we ignore it
        if (!matchesLength || !onlyDigits) return;

        _pinPutController.text = (await Clipboard.getData('text/plain')).text;
      },
      child: PinPut(
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
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        onSubmit: widget.onSubmit,
        keyboardType: TextInputType.number,
        useNativeKeyboard: true,
        inputFormatters: [
          FilteringTextInputFormatter.allow(widget.validator),
        ],
      ),
    );
  }
}
