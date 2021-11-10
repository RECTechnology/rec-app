import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rec/Components/Icons/RecCurrencyIcon.dart';
import 'package:rec/Components/Inputs/text_fields/RecTextField.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

/// [AmountTextField] renders a TextField, with some options for handling amounts.
/// Used when we need the user to enter an amount
class AmountTextField extends StatefulWidget {
  /// The initial value the field will initilize itself with
  final String initialValue;

  /// Called when [AmountTextField] changes value (ie: each time character is typed)
  final ValueChanged<String> onChange;

  /// Called when [RecTextField] is submitted
  final ValueChanged<String> onSubmitted;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  final FormFieldValidator<String> validator;

  final Color color;
  final bool readOnly;
  final bool autofocus;
  final String label;
  final Widget icon;

  const AmountTextField({
    Key key,
    this.initialValue,
    this.onChange,
    this.validator,
    this.color = Colors.black87,
    this.readOnly = false,
    this.autofocus = false,
    this.onSubmitted,
    this.label = 'AMOUNT',
    this.icon = const RecCurrencyIcon(color: Brand.grayLight),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AmountTextFieldState();
  }
}

class AmountTextFieldState extends State<AmountTextField> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return RecTextField(
      label: localizations.translate(widget.label),
      initialValue: widget.initialValue ?? '',
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
      ), //Used this type of keyboard to avoid error in  IOS with decimals
      needObscureText: false,
      placeholder: localizations.translate('WRITE_AMOUNT'),
      // onChange: widget.onChange,
      onChange: (value) {
        if (widget.onChange != null) {
          widget.onChange(value.isEmpty ? '0' : value.replaceAll(',', '.'));
        }
      },
      onSubmitted: (value) {
        if (widget.onSubmitted != null) {
          widget.onSubmitted(value.isEmpty ? '0' : value.replaceAll(',', '.'));
        }
      },
      colorLine: widget.color,
      validator: widget.validator,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      maxLines: 1,
      minLines: 1,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      icon: widget.icon,
    );
  }
}
