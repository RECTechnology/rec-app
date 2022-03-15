import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/pickers/gender_picker.dart';
import 'package:rec/Components/Inputs/pickers/year_picker.dart';
import 'package:rec/Components/Inputs/text_fields/RecTextField.dart';
import 'package:rec/helpers/validators/validators.dart';
import 'package:rec/Pages/Private/Shared/campaigns/culture/culture-campaign-extra.data.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class CultureExtraDataForm extends StatelessWidget {
  final CultureExtraData data;
  final GlobalKey<FormState> formKey;
  final ValueChanged<CultureExtraData> onChange;

  const CultureExtraDataForm({
    Key? key,
    required this.data,
    required this.onChange,
    required this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var hasYear = Checks.isNotEmpty(userState.user!.birthDate);
    var hasZip = Checks.isNotNull(userState.user!.zip);
    var hasGender = Checks.isNotEmpty(userState.user!.gender);

    return Form(
      key: formKey,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            if (!hasYear)
              YearInputPicker(
                onChanged: (DateTime value) {
                  data.birthYear = value;
                  onChange(data);
                },
                label: 'BIRTH_YEAR',
                value: data.birthYear,
                required: true,
              ),
            if (!hasGender)
              GenderPicker(
                onChanged: (value) {
                  data.gender = value!;
                  onChange(data);
                },
                value: data.gender,
              ),
            const SizedBox(height: 24),
            if (!hasZip)
              RecTextField(
                label: 'ZIP_CODE',
                placeholder: '00000',
                required: true,
                keyboardType: TextInputType.number,
                onChange: (value) {
                  data.zipCode = num.tryParse(value);
                  onChange(data);
                },
                validator: Validators.exactLength(
                  5,
                  message: 'ERROR_LENGTH_ZIP',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
