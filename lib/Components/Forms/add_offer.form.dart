import 'package:flutter/material.dart';
import 'package:rec/Components/Icons/currency_icon.dart';
import 'package:rec/Components/Inputs/OfferImage.dart';
import 'package:rec/Components/Inputs/OfferTypeSelector.dart';
import 'package:rec/Components/Inputs/form_fields/date_form_field.dart';
import 'package:rec/Components/Inputs/text_fields/AmountTextField.dart';
import 'package:rec/Components/Inputs/text_fields/SimpleTextField.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/helpers/validators/validators.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

/// Form for creating a new offer
class AddOfferForm extends StatelessWidget {
  final CreateOfferData data;
  final GlobalKey<FormState> formKey;
  final ValueChanged<CreateOfferData> onChange;

  const AddOfferForm({
    Key? key,
    required this.data,
    required this.onChange,
    required this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);

    return Form(
      key: formKey,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocalizedText('OFFER_TYPE'),
            const SizedBox(height: 16),
            OfferTypeSelector(
              type: data.type,
              onChange: (OfferType type) {
                onChange(data..type = type);
              },
            ),
            const SizedBox(height: 32),

            if (data.type == OfferType.classic) _recTypeRow(recTheme!),
            if (data.type == OfferType.percentage) _percentTypeRow(recTheme!),

            // Fields for all types
            SimpleTextField(
              initialValue: data.description,
              label: 'DESCRIPTION',
              onChange: (val) {
                onChange(data..description = val);
              },
            ),
            DateFormField(
              label: 'END_DATE',
              initialValue: data.end,
              validator: Validators.isRequired,
              onChange: (String? value) {
                onChange(data..end = value);
              },
            ),
            OfferImagePicker(
              imageUrl: data.image,
              onPicked: (image) {
                onChange(data..image = image);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _recTypeRow(RecThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AmountTextField(
              label: 'REGULAR_PRICE',
              initialValue: data.initialPrice == null ? '' : data.initialPrice.toString(),
              onChange: (val) {
                onChange(data..initialPrice = double.tryParse(val));
              },
              validator: Validators.isRequired,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: AmountTextField(
              label: 'DISCOUNT_PRICE',
              icon: CurrencyIcon(color: theme.grayLight),
              initialValue: data.offerPrice == null ? '' : data.offerPrice.toString(),
              onChange: (val) {
                onChange(data..offerPrice = double.tryParse(val));
              },
              validator: Validators.isRequired,
            ),
          ),
        ),
      ],
    );
  }

  Widget _percentTypeRow(RecThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AmountTextField(
              label: 'PERCENTAGE',
              icon: Icon(Icons.percent),
              initialValue: data.discount == null ? '' : data.discount.toString(),
              onChange: (val) {
                onChange(data..discount = double.tryParse(val));
              },
              validator: Validators.isRequired,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(),
          ),
        ),
      ],
    );
  }
}
