import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/AmountTextField.dart';
import 'package:rec/Components/Inputs/SimpleTextField.dart';
import 'package:rec/Entities/Forms/PaymentData.dart';
import 'package:rec/Helpers/Validators.dart';

class PayAddressForm extends StatefulWidget {
  final PaymentData data;
  final Function(PaymentData) onChange;
  final Function(PaymentData) onSubmitted;
  final GlobalKey<FormState> formKey;
  final List<String> disabledFields;

  const PayAddressForm({
    Key key,
    this.data,
    this.onChange,
    @required this.formKey,
    this.disabledFields = const [],
    this.onSubmitted,
  }) : super(key: key);

  @override
  _PayAddressForm createState() => _PayAddressForm();
}

class _PayAddressForm extends State<PayAddressForm> {
  bool _isFieldDisabled(String field) =>
      widget.disabledFields != null && widget.disabledFields.contains(field);

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
                widget.onChange(widget.data..concept = concept);
              },
              initialValue: widget.data.concept,
              validator: Validators.isRequired,
              readOnly: _isFieldDisabled('concept'),
            ),
            AmountTextField(
              initialValue: widget.data.amount == null
                  ? ''
                  : widget.data.amount.toString(),
              onSubmitted: (v) {
                widget.data.amount = double.parse(v.isEmpty ? '0' : v);
                if (widget.onSubmitted != null) widget.onSubmitted(widget.data);
              },
              onChange: (v) {
                widget.onChange(
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
