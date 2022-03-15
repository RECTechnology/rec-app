import 'package:flutter/material.dart';
import 'package:rec/Components/Forms/CreatePermission.form.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/config/brand.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class CreatePermission extends StatefulWidget {
  final Function? onCreated;

  CreatePermission({
    Key? key,
    this.onCreated,
  }) : super(key: key);

  @override
  _CreatePermissionState createState() => _CreatePermissionState();
}

class _CreatePermissionState extends State<CreatePermission> {
  final AccountsService _accountService = AccountsService(env: env);
  final _formKey = GlobalKey<FormState>();
  CreatePermissionData _data = CreatePermissionData(
    role: AccountPermission.ROLE_WORKER,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocalizedText('PERMISSIONS_DESC'),
        const SizedBox(height: 24),
        CreatePermissionForm(
          formKey: _formKey,
          data: _data,
          onChange: (data) {
            setState(() => _data.update(data));
          },
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _addUser,
            style: OutlinedButton.styleFrom(
              primary: Brand.grayDark,
              side: BorderSide(
                color: _data.isValid ? Brand.primaryColor : Brand.grayLight2,
              ),
              padding: const EdgeInsets.all(8.0),
            ),
            child: LocalizedText(
              'NEW_PERMISSION',
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: _data.isValid ? Brand.primaryColor : Brand.grayLight2,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  void _addUser() {
    if (!_formKey.currentState!.validate()) return;

    Loading.show();

    var userState = UserState.of(context, listen: false);

    _accountService
        .addUserToAccount(userState.account!.id, _data)
        .then(_createdPermissionOk)
        .catchError(_errorCreatingPermission);
  }

  void _createdPermissionOk(r) {
    setState(() {
      _data = CreatePermissionData(
        role: AccountPermission.ROLE_WORKER,
      );
    });

    _formKey.currentState!.reset();
    _formKey.currentState!.setState(() {});

    FocusScope.of(context).requestFocus(FocusNode());
    Loading.dismiss();
    RecToast.showSuccess(context, 'ADDED_USER_CORRECTLY');

    if (widget.onCreated != null) {
      widget.onCreated!();
    }
  }

  void _errorCreatingPermission(e) {
    Loading.dismiss();
    RecToast.showError(context, e.message);
  }
}
