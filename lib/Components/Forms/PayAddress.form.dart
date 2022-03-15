import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/text_fields/AmountTextField.dart';
import 'package:rec/Components/Inputs/text_fields/SimpleTextField.dart';
import 'package:rec/helpers/validators/validators.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

/// Form for asking for payment data
class PayAddressForm extends StatefulWidget {
  final PaymentData data;
  final GlobalKey<FormState> formKey;

  final ValueChanged<PaymentData?>? onChange;
  final ValueChanged<PaymentData?>? onSubmitted;

  final List<String?> disabledFields;

  const PayAddressForm({
    Key? key,
    required this.data,
    this.onChange,
    this.disabledFields = const [],
    this.onSubmitted,
    required this.formKey,
  }) : super(key: key);

  @override
  _PayAddressForm createState() => _PayAddressForm();
}

class _PayAddressForm extends State<PayAddressForm> {
  bool _isFieldDisabled(String field) => widget.disabledFields.contains(field);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
        child: Column(
          children: [
            SimpleTextField(
              label: 'CONCEPT',
              onChange: (concept) {
                widget.onChange!(widget.data..concept = concept);
              },
              initialValue: widget.data.concept,
              validator: Validators.isRequired,
              readOnly: _isFieldDisabled('concept'),
            ),
            AmountTextField(
              initialValue: widget.data.amount == null ? '' : widget.data.amount.toString(),
              onSubmitted: (v) {
                widget.data.amount = double.parse(v.isEmpty ? '0' : v);
                if (widget.onSubmitted != null) widget.onSubmitted!(widget.data);
              },
              onChange: (v) {
                widget.onChange!(
                  widget.data..amount = double.parse(v.isEmpty ? '0' : v),
                );
              },
              autofocus: true,
              validator: Validators.isRequired,
              readOnly: _isFieldDisabled('amount'),
            ),
          ],
        ),
      ),
    );
  }
}
