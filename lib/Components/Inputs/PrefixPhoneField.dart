import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecTextField.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class PrefixPhoneField extends StatefulWidget {
  final String prefix;
  final String phone;

  final Function(String phone) phoneChange;
  final Function(String prefix) prefixChange;
  final Function(String value) phoneValidator;

  final Color color;

  const PrefixPhoneField({
    Key key,
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
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            localizations.translate('TELEFONO'),
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
                  initialSelection: 'ES',
                  favorite: ['+34', 'ES'],
                  textStyle: TextStyle(fontSize: 16, color: Brand.grayDark),
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
                    color: Brand.grayIcon,
                  ),
                  colorLine: widget.color,
                  colorLabel: widget.color,
                  onChange: setPhone,
                  validator: widget.phoneValidator,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void setPhone(String phone) {
    widget.phoneChange(phone);
  }

  void setPrefix(CountryCode prefix) {
    widget.prefixChange(prefix.toString());
  }
}
