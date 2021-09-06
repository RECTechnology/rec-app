import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/DateInput.dart';
import 'package:rec/Components/Text/LocalizedText.dart';

class DateFormField extends FormField<String> {
  DateFormField({
    FormFieldSetter<String> onChange,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    String initialValue,
    String label = '',
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DateInput(
                  label: label,
                  value: state.value,
                  onChange: (String value) {
                    state.didChange(value);
                    if (onChange != null) onChange(value);
                  },
                ),
                state.hasError
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: LocalizedText(
                          state.errorText,
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : SizedBox.shrink()
              ],
            );
          },
        );
}
