import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:rec/brand.dart';

/// Renders a custom Pin Input
class RecPinInput extends StatefulWidget {
  /// Displayed fields count. PIN code length.
  final int fieldsCount;

  /// Called when [RecInputPin] is saved
  final ValueChanged<String> onSaved;

  /// Called when [RecInputPin] is submitted
  final ValueChanged<String> onSubmit;

  /// Called when the pin changes (ie: each time character is typed)
  final ValueChanged<String> onChanged;

  /// Whether the [RecInputPin] should be focused by default
  final bool autofocus;

  /// Validates the pin, agains a pattern r'\d{3}'
  final Pattern validator;

  /// Defines the keyboard focus for this widget.
  /// To give the keyboard focus to this widget, provide a [focusNode] and then
  /// use the current [FocusScope] to request the focus:
  final FocusNode focusNode;

  /// If the value is [true] the inputs will be obscured (replaced with *)
  final bool obscureText;

  RecPinInput({
    Key key,
    @required this.fieldsCount,
    this.onSaved,
    this.onSubmit,
    this.onChanged,
    this.autofocus = false,
    this.focusNode,
    this.obscureText = true,
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
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        fieldsCount: widget.fieldsCount,
        controller: _pinPutController,
        obscureText: widget.obscureText ? '*' : null,
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
