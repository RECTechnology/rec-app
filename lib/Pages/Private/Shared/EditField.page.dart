import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Inputs/text_fields/RecTextField.dart';
import 'package:rec/Components/Layout/FormPageLayout.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/config/theme.dart';

class EditFieldPage extends StatefulWidget {
  final String? fieldName;
  final String? initialValue;
  final String updateButtonText;
  final ValueChanged<String>? onSave;
  final IconData? icon;
  final FormFieldValidator<String>? validator;

  /// Override default fields
  final List<Widget>? fields;

  const EditFieldPage({
    Key? key,
    this.fieldName,
    this.initialValue,
    this.updateButtonText = 'UPDATE',
    this.icon = Icons.mail_outline,
    this.onSave,
    this.validator,
    this.fields,
  }) : super(key: key);

  @override
  _EditFieldPageState createState() => _EditFieldPageState();
}

class _EditFieldPageState extends State<EditFieldPage> {
  final _formKey = GlobalKey<FormState>();

  String fieldValue = '';

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);

    return FormPageLayout(
      appBar: EmptyAppBar(
        context,
        title: widget.fieldName,
      ),
      form: _form(),
      submitButton: RecActionButton(
        label: widget.updateButtonText,
        backgroundColor: recTheme!.primaryColor,
        onPressed: _onUpdate,
      ),
    );
  }

  Widget _form() {
    final recTheme = RecTheme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        children: widget.fields ??
            [
              RecTextField(
                initialValue: widget.initialValue,
                icon: Icon(widget.icon),
                label: widget.fieldName,
                colorLabel: recTheme!.grayLight3,
                validator: widget.validator,
                autofocus: true,
                maxLines: 1,
                onChange: (v) {
                  setState(() {
                    fieldValue = v;
                  });
                },
              ),
            ],
      ),
    );
  }

  void _onUpdate() {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).requestFocus(FocusNode());

    if (widget.onSave != null) widget.onSave!(fieldValue);
  }
}
