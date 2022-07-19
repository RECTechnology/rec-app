import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/providers/AppLocalizations.dart';

/// [RecTextField] is the main TextField widget used in the app,
/// independently or used in other widgets to add an extra layer, like [DniTextField]
class RecTextField extends StatefulWidget {
  /// Text that appears below the [InputDecorator.child] and the border.
  final String? placeholder;

  /// What keyboard type to use
  final TextInputType keyboardType;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard.
  /// Only supports text keyboards, other keyboard types will ignore this configuration. Capitalization is locale-aware.
  final TextCapitalization capitalizeMode;

  /// Optional input validation and formatting overrides.
  final List<TextInputFormatter> inputFormatters;

  /// Defines the keyboard focus for this widget.
  /// To give the keyboard focus to this widget, provide a [focusNode] and then
  /// use the current [FocusScope] to request the focus:
  final FocusNode? focusNode;

  final bool needObscureText;

  final bool required;

  /// Whether the [RecInputPin] should be focused by default
  final bool autofocus;

  /// Initial value of the TextField
  final String? initialValue;

  /// Text that describes the input field.
  final String? label;

  final Color colorLine;
  final Color colorLabel;
  final Color colorHint;

  final Widget? icon;

  final TextAlign textAlign;

  final double textSize;

  final double letterSpicing;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  final FormFieldValidator<String>? validator;

  /// Called when [RecTextField] changes value (ie: each time character is typed)
  final ValueChanged<String>? onChange;

  /// Called when [RecTextField] is submitted
  final ValueChanged<String>? onSubmitted;

  // Max amount of characters the field can contain
  final int? maxLength;

  final int maxLines;
  final int minLines;

  /// Whether the field can be written, or just read
  final bool readOnly;
  final bool enabled;

  final EdgeInsets padding;

  final TextEditingController? controller;

  RecTextField({
    this.keyboardType = TextInputType.text,
    this.needObscureText = false,
    this.colorLine = Colors.black87,
    this.colorLabel = Colors.black87,
    this.colorHint = Colors.black38,
    this.placeholder,
    this.onChange,
    this.icon,
    this.validator,
    this.initialValue,
    this.textSize = 16,
    this.textAlign = TextAlign.left,
    this.letterSpicing = 0.0,
    this.label,
    this.autofocus = false,
    this.capitalizeMode = TextCapitalization.none,
    this.readOnly = false,
    this.enabled = true,
    this.onSubmitted,
    this.inputFormatters = const [],
    this.focusNode,
    EdgeInsets? padding,
    this.minLines = 1,
    this.maxLines = 10,
    this.maxLength,
    this.controller,
    this.required = false,
  }) : padding = padding ?? const EdgeInsets.only(bottom: 24.0);

  @override
  _InputField createState() => _InputField();
}

class _InputField extends State<RecTextField> {
  String error = 'Contraseña incorrecta';
  bool obscureText = false;
  bool hasError = false;
  bool isNotIcon = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final translatedError = localizations!.translate(error);

    return Padding(
      padding: widget.padding,
      child: TextFormField(
        controller: widget.controller,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        textCapitalization: widget.capitalizeMode,
        initialValue: widget.initialValue,
        textAlign: widget.textAlign,
        autofocus: widget.autofocus,
        focusNode: widget.focusNode,
        maxLength: widget.maxLength,
        readOnly: widget.readOnly,
        inputFormatters: widget.inputFormatters,
        enabled: widget.enabled,
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 10),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: widget.colorLine),
          ),
          fillColor: Colors.lightBlueAccent,
          suffixIcon: widget.needObscureText
              ? IconButton(
                  onPressed: () => setState(() => changeObscureText()),
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Brand.grayIcon,
                  ),
                )
              : widget.icon,
          errorText: hasError ? translatedError : null,
          hintText: localizations.translate(widget.placeholder ?? ''),
          labelText: localizations.translate(widget.label ?? '') + (widget.required ? '*' : ''),
          labelStyle: TextStyle(height: 1.5, color: widget.colorLabel),
          hintStyle: TextStyle(height: 1.5, color: widget.colorHint),
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: widget.textSize,
          letterSpacing: widget.letterSpicing,
        ),
        onChanged: widget.enabled ? onChanged : null,
        onFieldSubmitted: widget.enabled ? widget.onSubmitted : null,
        obscureText: obscureText ? true : false,
        keyboardType: widget.keyboardType,
        validator: (v) {
          if (widget.validator == null) return null;

          var error = widget.validator!(v);
          if (error == null) return null;

          return localizations.translate(error);
        },
      ),
    );
  }

  void changeObscureText() {
    obscureText = !obscureText;
  }

  @override
  void initState() {
    super.initState();
    obscureText = widget.needObscureText;
  }

  void onChanged(String string) {
    if (widget.onChange != null) widget.onChange!(string);
  }
}
