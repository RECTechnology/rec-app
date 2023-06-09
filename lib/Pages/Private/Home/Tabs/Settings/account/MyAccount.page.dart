import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/PickImage.dart';
import 'package:rec/Components/Layout/ScrollableListLayout.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Components/ListTiles/SectionTitleTile.dart';
import 'package:rec/Components/Scaffold/BussinessHeader.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Pages/Private/Shared/EditField.page.dart';
import 'package:rec/config/features.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/validators/validators.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class MyAccountPage extends StatefulWidget {
  MyAccountPage({Key? key}) : super(key: key);

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final AccountsService _accountsService = AccountsService(env: env);

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var hasEmail = Checks.isNotEmpty(userState.account!.email);
    var tiles = [
      GeneralSettingsTile(
        title: Checks.isEmpty(userState.account!.name) ? 'NAME' : userState.account!.name,
        subtitle: 'ACCOUNT_NAME',
        onTap: _editName,
      ),
      GeneralSettingsTile(
        title: hasEmail ? userState.account!.email : 'EMAIL_ONLY',
        subtitle: hasEmail ? 'EMAIL_ONLY' : 'CHANGE_EMAIL',
        onTap: _editEmail,
      ),
    ];

    return ScrollableListLayout.separated(
      appBar: EmptyAppBar(context, title: 'SETTINGS_MY_ACCOUNT'),
      physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
          color: Colors.white,
          child: BussinessHeader(
            userState.account,
            avatarBadge: Features.imageUploads
                ? Positioned(
                    bottom: -8,
                    right: -4,
                    child: PickImage(
                      onPick: _changeImage,
                      title: 'IMAGE_DE_CUENTA',
                      buttonLabel: 'UPDATE',
                      hint: 'IMAGE_DE_CUENTA_DESC',
                    ),
                  )
                : null,
            subtitle: const SizedBox.shrink(),
          ),
        ),
        SectionTitleTile('YOUR_ACCOUNT'),
        ...tiles
      ],
    );
  }

  void _editField({
    String fieldName = 'FIELD',
    FormFieldValidator<String> validator = Validators.isRequired,
    String? initialValue,
    IconData? icon,
    String? apiFieldName,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EditFieldPage(
          initialValue: initialValue,
          fieldName: fieldName,
          icon: icon,
          validator: validator,
          onSave: (value) {
            _updateAccount({
              (apiFieldName ?? fieldName.toLowerCase()): value,
            });
          },
        ),
      ),
    );
  }

  void _changeImage(String link) {
    _updateAccount({
      'company_image': link,
    });
  }

  void _editName() async {
    var userState = UserState.of(context, listen: false);
    if (Features.uneditableAccountNames.contains(userState.account?.name)) {
      RecToast.showInfo(context, 'NOT_EDITABLE');
      return;
    }

    return _editField(
      fieldName: 'NAME',
      icon: Icons.person,
      initialValue: userState.account!.name,
      validator: Validators.isRequired,
    );
  }

  void _editEmail() async {
    var userState = UserState.of(context, listen: false);

    return _editField(
      fieldName: 'EMAIL_ONLY',
      icon: Icons.mail_outline,
      initialValue: userState.account!.email,
      validator: Validators.isEmail,
      apiFieldName: 'email',
    );
  }

  void _updateAccount(Map<String, dynamic> data) {
    if (isLoading) return;

    isLoading = true;

    Loading.show();

    var userState = UserState.of(context, listen: false);
    _accountsService
        .updateAccount(userState.account!.id, data)
        .then(_updateOk)
        .catchError(_onError);
  }

  Future<void> _updateOk(c) async {
    var userState = UserState.of(context, listen: false);
    await userState.getUser();

    Navigator.pop(context);

    isLoading = false;
    await Loading.dismiss();
    RecToast.showSuccess(context, 'UPDATED_OK');
  }

  void _onError(e) {
    isLoading = false;
    Loading.dismiss();
    RecToast.showError(context, e.message);
  }
}
