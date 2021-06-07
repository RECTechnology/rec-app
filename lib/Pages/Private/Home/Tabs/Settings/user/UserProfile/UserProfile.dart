import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Api/Services/UsersService.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';

import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Helpers/Checks.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Helpers/Validators.dart';
import 'package:rec/Pages/Private/Shared/EditField.page.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final UsersService _userService = UsersService();

  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var localization = AppLocalizations.of(context);
    var emailTitle = Checks.isNotEmpty(userState.user.email)
        ? userState.user.email
        : 'EMAIL_ONLY';

    var tiles = [
      GeneralSettingsTile(
        title: userState.user.username,
        subtitle: localization.translate('DNI_NIE'),
        disabled: true,
      ),
      GeneralSettingsTile(
        title: userState.user.formattedPhone,
        subtitle: localization.translate('TELEFONO'),
        disabled: true,
      ),
      GeneralSettingsTile(
        title: emailTitle,
        subtitle: 'CHANGE_EMAIL',
        onTap: _goToEditEmail,
      ),
    ];

    return Scaffold(
      backgroundColor: Brand.defaultAvatarBackground,
      appBar: EmptyAppBar(context, title: 'SETTINGS_USER_PROFILE'),
      body: Scrollbar(
        thickness: 8,
        showTrackOnHover: true,
        radius: Radius.circular(3),
        child: ListView.separated(
          itemBuilder: (ctx, index) => tiles[index],
          separatorBuilder: (ctx, index) => Divider(height: 1),
          itemCount: tiles.length,
        ),
      ),
    );
  }

  void _goToEditEmail() async {
    var userState = UserState.of(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EditFieldPage(
          initialValue: userState.user.email,
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

    Navigator.pop(context);
    await Loading.dismiss();

    RecToast.showSuccess(context, 'UPDATED_OK');
  }

  void _onError(e) {
    Loading.dismiss();
    RecToast.showError(context, e.message);
  }
}
