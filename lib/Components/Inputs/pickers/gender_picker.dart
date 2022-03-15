import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/genders.dart';
import 'package:rec/helpers/validators/validators.dart';
import 'package:rec/providers/AppLocalizations.dart';

class GenderPicker extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;

  const GenderPicker({
    Key? key,
    this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return DropdownButtonFormField<String>(
      value: value,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      onChanged: onChanged,
      validator: (v) {
        var error = Validators.isRequired(v);
        return error == null ? null : localizations!.translate(error);
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: localizations!.translate('GENDER') + '*',
        labelStyle: TextStyle(height: 1.5),
      ),
      items: GENDERS.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: LocalizedText(value),
        );
      }).toList(),
    );
  }
}
