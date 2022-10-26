import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/text_fields/RecTextField.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/providers/app_localizations.dart';

/// [CifTextField] renders a TextField, with some options for handling DNIs
/// Used when we need the user to enter a DNI
class CifTextField extends StatefulWidget {
  /// The initial value the field will initilize itself with
  final String? initialValue;

  /// The color of the widget
  final Color color;

  /// Called when [RecTextField] changes value (ie: each time character is typed)
  final ValueChanged<String?>? onChange;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  final FormFieldValidator<String>? validator;

  final String? labelText;

  final String? placeholderText;

  final EdgeInsets? padding;

  final bool showIcon;

  const CifTextField({
    Key? key,
    this.initialValue,
    this.onChange,
    this.validator,
    this.color = Colors.black87,
    this.labelText = 'CIF',
    this.placeholderText = 'CIF',
    this.padding,
    this.showIcon = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CifTextFieldState();
  }
}

class CifTextFieldState extends State<CifTextField> {
  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    final localizations = AppLocalizations.of(context);
    final localizedLabel = localizations!.translate(
      widget.labelText ?? widget.placeholderText ?? 'CIF',
    );
    final localizedPlaceholder = localizations.translate(
      widget.placeholderText ?? widget.labelText ?? 'CIF',
    );

    return RecTextField(
      label: localizedLabel,
      initialValue: widget.initialValue,
      keyboardType: TextInputType.text,
      needObscureText: false,
      placeholder: localizedPlaceholder,
      onChange: _fieldChanged,
      colorLine: widget.color,
      validator: widget.validator,
      padding: widget.padding,
      maxLines: 1,
      minLines: 1,
      icon: widget.showIcon
          ? Icon(
              Icons.work_outlined,
              color: recTheme!.grayLight3,
            )
          : null,
    );
  }

  void _fieldChanged(value) {
    // Trim whitespaces at the end and start of the [value]
    // prevents incorrect validation in case a user adds a space at the end
    if (widget.onChange != null) {
      widget.onChange!(value.trim());
    }
  }
}
