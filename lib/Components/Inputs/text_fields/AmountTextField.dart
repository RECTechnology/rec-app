import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rec/Components/Icons/currency_icon.dart';
import 'package:rec/Components/Inputs/text_fields/RecTextField.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/providers/app_localizations.dart';

/// [AmountTextField] renders a TextField, with some options for handling amounts.
/// Used when we need the user to enter an amount
class AmountTextField extends StatefulWidget {
  /// The initial value the field will initilize itself with
  final String? initialValue;

  /// Called when [AmountTextField] changes value (ie: each time character is typed)
  final ValueChanged<String>? onChange;

  /// Called when [RecTextField] is submitted
  final ValueChanged<String>? onSubmitted;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  final FormFieldValidator<String?>? validator;

  final TextEditingController? controller;

  final Color color;
  final bool readOnly;
  final bool autofocus;
  final bool enabled;
  final String label;
  final Widget? icon;

  const AmountTextField({
    Key? key,
    this.initialValue,
    this.onChange,
    this.validator,
    this.color = Colors.black87,
    this.readOnly = false,
    this.autofocus = false,
    this.enabled = true,
    this.onSubmitted,
    this.label = 'AMOUNT',
    this.icon,
    this.controller,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AmountTextFieldState();
  }
}

class AmountTextFieldState extends State<AmountTextField> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final recTheme = RecTheme.of(context);

    return RecTextField(
      label: localizations!.translate(widget.label),
      initialValue: widget.initialValue,
      controller: widget.controller,
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
      ), //Used this type of keyboard to avoid error in  IOS with decimals
      needObscureText: false,
      placeholder: localizations.translate('WRITE_AMOUNT'),
      onChange: (value) {
        if (widget.onChange != null) {
          widget.onChange!(value.isEmpty ? '0' : value.replaceAll(',', '.'));
        }
      },
      onSubmitted: (value) {
        if (widget.onSubmitted != null) {
          widget.onSubmitted!(value.isEmpty ? '0' : value.replaceAll(',', '.'));
        }
      },
      colorLine: widget.color,
      validator: widget.validator,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      maxLines: 1,
      minLines: 1,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
      ],
      icon: FittedBox(
        child: widget.icon ?? CurrencyIcon(color: recTheme!.grayLight, size: 20),
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
