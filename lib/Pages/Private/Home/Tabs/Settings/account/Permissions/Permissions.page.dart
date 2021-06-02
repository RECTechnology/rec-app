import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Api/Services/AccountsService.dart';
import 'package:rec/Components/ListTiles/AccountPermissionTile.dart';
import 'package:rec/Components/Modals/YesNoModal.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Entities/AccountPermission.ent.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/account/Permissions/CreatePermission.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';

// TODO: Change roles per permission
// TODO: Improve yes/no dialog
// TODO: TEST

class AccountPermissionsPage extends StatefulWidget {
  AccountPermissionsPage({Key key}) : super(key: key);

  @override
  _AccountPermissionsPageState createState() => _AccountPermissionsPageState();
}

class _AccountPermissionsPageState extends State<AccountPermissionsPage> {
  final _accountService = AccountsService();

  List<AccountPermission> _users = [];
  UserState userState;

  @override
  void didChangeDependencies() {
    if (userState == null) {
      userState = UserState.of(context, listen: false);
      _loadPermissions();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EmptyAppBar(
        context,
        title: 'SETTINGS_ACCOUNT_PERMISSIONS',
        actions: [
          IconButton(
            icon: Icon(Icons.help, color: Brand.grayDark),
            onPressed: () {},
          )
        ],
      ),
      body: Scrollbar(
        thickness: 8,
        showTrackOnHover: true,
        radius: const Radius.circular(3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: Paddings.page,
              child: CreatePermission(
                onCreated: _permissionCreated,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(
                localizations.translate('USERS'),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _permissionsList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _permissionsList() {
    return _users.isNotEmpty
        ? ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return AccountPermissionTile(
                _users[index],
                onDelete: () => _deletePermission(_users[index]),
                onChangeRole: (role) => _changeRole(_users[index], role),
              );
            },
            itemCount: _users.length,
            separatorBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(),
              );
            },
          )
        : Center(child: CircularProgressIndicator());
  }

  void _permissionCreated() {
    _loadPermissions();
  }

  void _loadPermissions() {
    _accountService.listAccountPermissions(userState.account.id).then((value) {
      setState(() => _users = value.items);
    });
  }

  void _deletePermission(AccountPermission permission) async {
    var yesNoModal = YesNoModal(
      title: LocalizedText('REMOVE_USER'),
      content: LocalizedText('REMOVE_USER_DESC'),
      context: context,
    );

    var dialogResult = await yesNoModal.showDialog(context);

    // Only remove if users accepts dialog
    if (dialogResult == true) {
      var userState = UserState.of(context, listen: false);

      await Loading.show();
      await _accountService
          .deleteUserFromAccount(userState.account.id, permission.id)
          .then(_removedOk)
          .catchError(_onError);
    }
  }

  void _changeRole(AccountPermission permission, String role) async {
    await Loading.show();

    var userState = UserState.of(context, listen: false);
    await _accountService
        .updateUserInAccount(
          userState.account.id,
          permission.id,
          role,
        )
        .then(_updatedRoleOk)
        .catchError(_onError);
  }

  void _removedOk(c) {
    Loading.dismiss();
    RecToast.showSuccess(context, 'REMOVED_USER_CORRECTLY');
    _loadPermissions();
  }

  void _updatedRoleOk(c) {
    Loading.dismiss();
    RecToast.showSuccess(context, 'UPDATED_USER_CORRECTLY');
    _loadPermissions();
  }

  void _onError(e) {
    Loading.dismiss();
    RecToast.showError(context, e.message);
  }
}
