import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:rec/config/theme.dart';

/// Renders a custom Pin Input
class RecPinInput extends StatefulWidget {
  /// Displayed fields count. PIN code length.
  final int fieldsCount;

  /// Called when [RecInputPin] is saved
  final ValueChanged<String?>? onSaved;

  /// Called when [RecInputPin] is submitted
  final ValueChanged<String>? onSubmit;

  /// Called when the pin changes (ie: each time character is typed)
  final ValueChanged<String>? onChanged;

  /// Whether the [RecInputPin] should be focused by default
  final bool autofocus;

  /// Validates the pin, agains a pattern r'\d{3}'
  final Pattern validator;

  /// Defines the keyboard focus for this widget.
  /// To give the keyboard focus to this widget, provide a [focusNode] and then
  /// use the current [FocusScope] to request the focus:
  final FocusNode? focusNode;

  /// If the value is [true] the inputs will be obscured (replaced with *)
  final bool obscureText;

  final double size;

  RecPinInput({
    Key? key,
    required this.fieldsCount,
    this.onSaved,
    this.onSubmit,
    this.onChanged,
    this.autofocus = false,
    this.focusNode,
    this.obscureText = true,
    this.size = 40,
    Pattern? validator,
  })  : validator = validator ?? RegExp(r'[0-9]'),
        super(key: key);

  @override
  _RecPinInputState createState() => _RecPinInputState();
}

class _RecPinInputState extends State<RecPinInput> {
  final TextEditingController _pinPutController = TextEditingController();

  TextStyle get _textStyle => TextStyle(fontSize: 18);

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(6.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    
    return GestureDetector(
      onLongPress: () async {
        var clipboardContent = (await Clipboard.getData('text/plain'))!.text!;
        var matchesLength = clipboardContent.length == widget.fieldsCount;
        var onlyDigits = clipboardContent.contains(widget.validator);

        // If the clipboardContent does not fit the current pin format, we ignore it
        if (!matchesLength || !onlyDigits) return;

        _pinPutController.text = (await Clipboard.getData('text/plain'))!.text!;
      },
      child: Pinput(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        length: widget.fieldsCount,
        controller: _pinPutController,
        obscureText: widget.obscureText,
        obscuringCharacter: '*',
        focusedPinTheme: PinTheme(
          width: widget.size,
          height: widget.size,
          textStyle: _textStyle,
          decoration: _pinPutDecoration.copyWith(
            border: Border.all(
              color: recTheme!.primaryColor.withOpacity(.5),
              width: 2,
            ),
          ),
        ),
        followingPinTheme: PinTheme(
          width: widget.size,
          height: widget.size,
          textStyle: _textStyle,
          decoration: _pinPutDecoration.copyWith(
            border: Border.all(
              color: Colors.black.withOpacity(.5),
            ),
          ),
        ),
        submittedPinTheme: PinTheme(
          width: widget.size,
          height: widget.size,
          textStyle: _textStyle,
          decoration: _pinPutDecoration,
        ),
        onCompleted: widget.onSaved,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmit,
        keyboardType: TextInputType.number,
        useNativeKeyboard: true,
        inputFormatters: [
          FilteringTextInputFormatter.allow(widget.validator),
        ],
      ),
    );
  }
}
