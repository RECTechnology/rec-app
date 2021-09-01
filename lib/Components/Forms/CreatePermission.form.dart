import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/text_fields/DniTextField.dart';
import 'package:rec/Components/Inputs/RoleSelector.dart';
import 'package:rec/Entities/Forms/CreatePermissionData.dart';
import 'package:rec/Helpers/Validators.dart';

/// Form for changing pin, used by [ChangedPinPage]
class CreatePermissionForm extends StatefulWidget {
  /// Controls how one widget replaces another widget in the tree.
  final GlobalKey<FormState> formKey;

  /// Initial form data
  final CreatePermissionData data;

  /// Called when pin changed
  final ValueChanged<CreatePermissionData> onChange;

  const CreatePermissionForm({
    Key key,
    @required this.onChange,
    @required this.data,
    this.formKey,
  }) : super(key: key);

  @override
  CreatePermissionFormState createState() {
    return CreatePermissionFormState();
  }
}

class CreatePermissionFormState extends State<CreatePermissionForm> {
  final FocusNode repinFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: DniTextField(
                  showIcon: false,
                  onChange: (dni) {
                    setState(() => widget.data.dni = dni);
                    widget.onChange(widget.data);
                  },
                  validator: Validators.validateCif,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, top: 8),
                  child: RoleSelector(
                    role: widget.data.role,
                    onChanged: (role) {
                      setState(() => widget.data.role = role);
                      widget.onChange(widget.data);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
