import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class RecTextField extends StatefulWidget {
  /// Text that appears below the [InputDecorator.child] and the border.
  final String placeholder;

  /// What keyboard type to use
  final TextInputType keyboardType;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard.
  /// Only supports text keyboards, other keyboard types will ignore this configuration. Capitalization is locale-aware.
  final TextCapitalization capitalizeMode;

  /// Optional input validation and formatting overrides.
  final List<TextInputFormatter> inputFormatters;

  final bool isNumeric;
  final bool needObscureText;
  final bool isPassword;
  final bool isPhone;
  final bool autofocus;

  final String initialValue;
  final String label;

  final Color colorLine;
  final Color colorLabel;
  final Icon icon;
  final Function validator;
  final TextAlign textAlign;
  final double textSize;
  final double letterSpicing;

  final Function(String string) onChange;
  final Function(String string) onSubmitted;

  final int maxLength;
  final bool readOnly;

  RecTextField({
    this.keyboardType = TextInputType.text,
    this.isNumeric = false,
    this.needObscureText = false,
    this.isPassword = false,
    this.colorLine = Colors.black87,
    this.colorLabel = Colors.black87,
    this.placeholder,
    this.onChange,
    this.icon,
    this.validator,
    this.isPhone,
    this.initialValue,
    this.textSize = 16,
    this.textAlign = TextAlign.left,
    this.letterSpicing = 0.0,
    this.maxLength,
    this.label,
    this.autofocus = false,
    this.capitalizeMode = TextCapitalization.none,
    this.readOnly = false,
    this.onSubmitted,
    this.inputFormatters = const [],
  });

  @override
  _InputField createState() => _InputField();
}

class _InputField extends State<RecTextField> {
  bool obscureText = false;
  bool hasError = false;
  String error = 'Contraseña incorrecta';
  bool isNotIcon = false;

  @override
  void initState() {
    super.initState();
    obscureText = widget.needObscureText;
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var translatedError = localizations.translate(error);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: TextFormField(
        textCapitalization: widget.capitalizeMode,
        initialValue: widget.initialValue ?? '',
        textAlign: widget.textAlign,
        autofocus: widget.autofocus,
        maxLength: widget.maxLength,
        readOnly: widget.readOnly,
        inputFormatters: widget.inputFormatters,
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
          hintText: widget.placeholder,
          labelText: widget.label,
          labelStyle: TextStyle(height: 1.5, color: widget.colorLabel),
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: widget.textSize,
          letterSpacing: widget.letterSpicing,
        ),
        onChanged: onChanged,
        onFieldSubmitted: widget.onSubmitted,
        obscureText: obscureText ? true : false,
        keyboardType: widget.keyboardType,
        validator: (v) {
          var error = widget.validator(v);
          if (error == null) return null;

          return localizations.translate(error);
        },
      ),
    );
  }

  void onChanged(String string) {
    // if (widget.needObscureText == true) {
    //   setState(() {
    //     isNotIcon = true;
    //   });
    // }
    widget.onChange(string);
  }

  void changeObscureText() {
    obscureText = !obscureText;
  }
}
