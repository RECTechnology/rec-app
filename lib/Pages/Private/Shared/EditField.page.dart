import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Inputs/RecTextField.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';

class EditFieldPage extends StatefulWidget {
  final String fieldName;
  final String initialValue;
  final String updateButtonText;
  final ValueChanged<String> onSave;
  final IconData icon;
  final FormFieldValidator<String> validator;

  /// Override default fields
  final List<Widget> fields;

  const EditFieldPage({
    Key key,
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
    var localizations = AppLocalizations.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: EmptyAppBar(
          context,
          title: widget.fieldName,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: Paddings.pageNoTop,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 43.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: widget.fields ??
                          [
                            RecTextField(
                              initialValue: widget.initialValue,
                              icon: Icon(widget.icon),
                              label: localizations.translate(widget.fieldName),
                              colorLabel: Brand.grayDark4,
                              validator: widget.validator,
                              onChange: (v) {
                                setState(() {
                                  fieldValue = v;
                                });
                              },
                            ),
                          ],
                    ),
                  ),
                ),
                RecActionButton(
                  label: localizations.translate(widget.updateButtonText),
                  backgroundColor: Brand.primaryColor,
                  onPressed: _onUpdate,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onUpdate() {
    if (!_formKey.currentState.validate()) return;

    FocusScope.of(context).requestFocus(FocusNode());

    if (widget.onSave != null) widget.onSave(fieldValue);
  }
}
