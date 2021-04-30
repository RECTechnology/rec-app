import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/AmountTextField.dart';
import 'package:rec/Components/Inputs/SimpleTextField.dart';
import 'package:rec/Entities/Forms/PaymentData.dart';
import 'package:rec/Helpers/Validators.dart';

class PayAddressForm extends StatefulWidget {
  final PaymentData data;
  final Function(PaymentData) onChange;
  final GlobalKey<FormState> formKey;

  const PayAddressForm({
    Key key,
    this.data,
    this.onChange,
    @required this.formKey,
  }) : super(key: key);

  @override
  _PayAddressForm createState() => _PayAddressForm();
}

class _PayAddressForm extends State<PayAddressForm> {
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
            ),
            AmountTextField(
              onChange: (v) {
                widget.onChange(
                  widget.data..amount = double.parse(v.isEmpty ? '0' : v),
                );
              },
              validator: Validators.isRequired,
            ),
          ],
        ),
      ),
    );
  }
}
