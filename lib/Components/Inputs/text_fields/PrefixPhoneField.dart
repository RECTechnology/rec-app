import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/text_fields/RecTextField.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/helpers/validators/phone_validator.dart';
import 'package:rec/providers/AppLocalizations.dart';

class PrefixPhoneField extends StatefulWidget {
  final String? prefix;
  final String? phone;

  final ValueChanged<String>? phoneChange;
  final ValueChanged<String>? prefixChange;
  final FormFieldValidator<String>? phoneValidator;

  final Color color;

  const PrefixPhoneField({
    Key? key,
    this.prefix,
    this.phone,
    this.phoneChange,
    this.prefixChange,
    this.color = Colors.black87,
    this.phoneValidator,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PrefixPhoneFieldState();
  }
}

class PrefixPhoneFieldState extends State<PrefixPhoneField> {
  final phoneValidator = PhoneValidator();

  @override
  void initState() {
    phoneValidator.setPrefix(widget.prefix!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final recTheme = RecTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            localizations!.translate('TELEFONO'),
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.topCenter,
                child: CountryCodePicker(
                  onChanged: setPrefix,
                  enabled: false,
                  // NOTE: having `+34` hardcoded is temporal so  we only allow spanish numbers,
                  // it might change in the future.
                  initialSelection: '+34',
                  favorite: ['+34', 'ES'],
                  textStyle: TextStyle(fontSize: 16, color: recTheme!.grayDark),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RecTextField(
                  placeholder: localizations.translate('TELEFONO'),
                  keyboardType: TextInputType.phone,
                  icon: Icon(
                    Icons.phone,
                    color: recTheme.grayLight3,
                  ),
                  colorLine: widget.color,
                  colorLabel: widget.color,
                  onChange: setPhone,
                  validator: (value) {
                    var validationResult = phoneValidator.validate(value);
                    if (validationResult != null) return validationResult;

                    return widget.phoneValidator != null ? widget.phoneValidator!(value) : null;
                  },
                  initialValue: widget.phone,
                  maxLines: 1,
                  minLines: 1,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void setPhone(String phone) {
    if (widget.phoneChange != null) {
      widget.phoneChange!(phone.trim());
    }
  }

  void setPrefix(CountryCode prefix) {
    phoneValidator.setPrefix(prefix.toString());
    if (widget.prefixChange != null) {
      widget.prefixChange!(prefix.toString().trim());
    }
  }
}
