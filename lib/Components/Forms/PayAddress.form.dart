import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/text_fields/AmountTextField.dart';
import 'package:rec/Components/Inputs/text_fields/SimpleTextField.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/helpers/validators/validators.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

/// Form for asking for payment data
class PayAddressForm extends StatefulWidget {
  final PaymentData data;
  final GlobalKey<FormState> formKey;

  final VoidCallback? onValidate;
  final ValueChanged<PaymentData?>? onChange;
  final ValueChanged<PaymentData?>? onSubmitted;

  final List<String?> disabledFields;

  /// Specify the max amount that can be sent
  ///
  /// If [maxAmount] is not null, a slider will be added that allows to set the max amount
  final double? maxAmount;

  const PayAddressForm({
    Key? key,
    required this.data,
    this.onChange,
    this.disabledFields = const [],
    this.onValidate,
    this.onSubmitted,
    required this.formKey,
    this.maxAmount,
  }) : super(key: key);

  @override
  _PayAddressForm createState() => _PayAddressForm();
}

class _PayAddressForm extends State<PayAddressForm> {
  late PaymentData _data;
  bool _forceMaxAmount = false;
  bool _isFieldDisabled(String field) => widget.disabledFields.contains(field);

  final _amountController = TextEditingController(text: '');

  @override
  void initState() {
    _data = widget.data;
    if (_data.amount != null) {
      _amountController.text = _data.amount.toString();
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _data = widget.data;
    if (_data.amount != null) {
      _amountController.text = _data.amount.toString();
    }
    super.didChangeDependencies();
  }

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
                widget.onChange!(_data..concept = concept);
              },
              initialValue: _data.concept,
              validator: Validators.isRequired,
              readOnly: _isFieldDisabled('concept'),
            ),
            AmountTextField(
              controller: _amountController,
              onSubmitted: (v) {
                _data.amount = double.parse(v.isEmpty ? '0' : v);
                if (widget.onSubmitted != null) widget.onSubmitted!(_data);
              },
              onChange: (v) {
                widget.onChange!(
                  _data..amount = double.parse(v.isEmpty ? '0' : v),
                );
              },
              enabled: !_forceMaxAmount,
              autofocus: true,
              validator: Validators.combine([
                Validators.isRequired,
                if (widget.maxAmount != null)
                  Validators.maxAmount(double.parse(
                    widget.maxAmount!.toStringAsFixed(2),
                  )),
              ]),
              readOnly: _isFieldDisabled('amount'),
            ),
            if (widget.maxAmount != null)
              Row(
                children: [
                  Switch(
                    value: _forceMaxAmount,
                    onChanged: (newValue) {
                      setState(() {
                        _forceMaxAmount = newValue;

                        if (_forceMaxAmount) {
                          _data.amount = double.parse(
                            (widget.maxAmount ?? 0).toStringAsFixed(2),
                          );
                          _amountController.text = _data.amount.toString();
                        } else {
                          _data.amount = null;
                          _amountController.text = '';
                        }

                        if (widget.onValidate != null) widget.onChange!(_data);
                        if (widget.onValidate != null) widget.onValidate!();
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  LocalizedText('MAX_AMOUNT',
                      params: {'max': widget.maxAmount!.toStringAsFixed(2)}),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
