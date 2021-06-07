import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecTextField.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

/// [DniTextField] renders a TextField, with some options for handling DNIs
/// Used when we need the user to enter a DNI
class DniTextField extends StatefulWidget {
  /// The initial value the field will initilize itself with
  final String initialValue;

  /// The color of the widget
  final Color color;

  /// Called when [RecTextField] changes value (ie: each time character is typed)
  final ValueChanged<String> onChange;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  final FormFieldValidator<String> validator;

  final String labelText;

  final String placeholderText;

  final EdgeInsets padding;

  final bool showIcon;

  const DniTextField({
    Key key,
    this.initialValue,
    this.onChange,
    this.validator,
    this.color = Colors.black87,
    this.labelText = 'DNI_NIE',
    this.placeholderText = 'DNI_NIE',
    this.padding,
    this.showIcon = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DniTextFieldState();
  }
}

class DniTextFieldState extends State<DniTextField> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var localizedLabel = localizations.translate(
      widget.labelText ?? widget.placeholderText,
    );
    var localizedPlaceholder = localizations.translate(
      widget.placeholderText ?? widget.labelText,
    );

    return RecTextField(
      label: localizedLabel,
      initialValue: widget.initialValue,
      keyboardType: TextInputType.text,
      needObscureText: false,
      placeholder: localizedPlaceholder,
      onChange: widget.onChange,
      colorLine: widget.color,
      validator: widget.validator,
      padding: widget.padding,
      maxLines: 1,
      minLines: 1,
      icon: widget.showIcon
          ? Icon(
              Icons.person,
              color: Brand.grayIcon,
            )
          : null,
    );
  }
}
