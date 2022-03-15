import 'package:flutter/material.dart';
import 'package:rec/Components/Layout/ScrollableListLayout.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Pages/Private/Shared/EditField.page.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/validators/validators.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final UsersService _userService = UsersService(env: env);

  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var hasEmail = Checks.isNotEmpty(userState.user!.email);
    var emailTitle = hasEmail ? userState.user!.email : 'EMAIL_ONLY';
    var tiles = [
      GeneralSettingsTile(
        title: userState.user!.username,
        subtitle: 'DNI_NIE',
        disabled: true,
      ),
      GeneralSettingsTile(
        title: userState.user!.formattedPhone,
        subtitle: 'TELEFONO',
        disabled: true,
      ),
      GeneralSettingsTile(
        title: emailTitle,
        subtitle: hasEmail ? 'EMAIL_ONLY' : 'CHANGE_EMAIL',
        onTap: _goToEditEmail,
      ),
    ];

    return ScrollableListLayout.separated(
      appBar: EmptyAppBar(context, title: 'SETTINGS_USER_PROFILE'),
      children: tiles,
    );
  }

  // coverage:ignore-next
  void _goToEditEmail() async {
    var userState = UserState.of(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EditFieldPage(
          initialValue: userState.user!.email,
          fieldName: 'EMAIL_ONLY',
          icon: Icons.mail_outline,
          validator: Validators.isEmail,
          onSave: (newEmail) {
            _updateEmail(newEmail);
          },
        ),
      ),
    );
  }

  void _updateEmail(String newEmail) {
    Loading.show();
    _userService
        .updateUser({
          'email': newEmail,
        })
        .then(_updateOk)
        .catchError(_onError);
  }

  Future<void> _updateOk(c) async {
    var userState = UserState.of(context, listen: false);

    await userState.getUser();
    await Loading.dismiss();

    Navigator.pop(context);
    RecToast.showSuccess(context, 'UPDATED_OK');
  }

  void _onError(e) {
    Loading.dismiss();
    RecToast.showError(context, e.message);
  }
}
