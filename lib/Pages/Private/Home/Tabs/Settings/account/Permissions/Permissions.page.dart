import 'package:flutter/material.dart';
import 'package:rec/Components/ListTiles/AccountPermissionTile.dart';
import 'package:rec/Components/Modals/YesNoModal.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/account/Permissions/CreatePermission.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/styles/paddings.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class AccountPermissionsPage extends StatefulWidget {
  final AccountsService accountsService;

  AccountPermissionsPage({
    Key? key,
    AccountsService? accountsService,
  })  : accountsService = accountsService ?? AccountsService(env: env),
        super(key: key);

  @override
  _AccountPermissionsPageState createState() => _AccountPermissionsPageState();
}

class _AccountPermissionsPageState extends State<AccountPermissionsPage> {
  AccountsService get _accountService => widget.accountsService;

  List<AccountPermission>? _users = [];
  UserState? userState;

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EmptyAppBar(
        context,
        title: 'SETTINGS_ACCOUNT_PERMISSIONS',
      ),
      body: Scrollbar(
        thickness: 8,
        trackVisibility: true,
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
              child: LocalizedText(
                'USERS',
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
    final recTheme = RecTheme.of(context);

    return _users!.isNotEmpty
        ? RefreshIndicator(
            color: recTheme?.primaryColor,
            onRefresh: _loadPermissions,
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return AccountPermissionTile(
                  _users![index],
                  key: Key(_users![index].id.toString()),
                  onDelete: () => _deletePermission(_users![index]),
                  onChangeRole: (role) => _changeRole(_users![index], role!),
                );
              },
              itemCount: _users!.length,
              separatorBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(),
                );
              },
            ),
          )
        : Center(child: CircularProgressIndicator());
  }

  void _permissionCreated() async {
    await _loadPermissions();
  }

  Future<void> _loadPermissions() {
    return _accountService.listAccountPermissions(userState!.account!.id).then((value) {
      setState(() => _users = value.items);
      for (var p in _users!) {
        print('User ${p.username} > ${p.roles!.join(', ')}');
      }
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
          .deleteUserFromAccount(userState.account!.id, permission.id)
          .then(_removedOk)
          .catchError(_onError);
    }
  }

  void _changeRole(AccountPermission permission, String role) async {
    await Loading.show();

    var userState = UserState.of(context, listen: false);
    await _accountService
        .updateUserInAccount(
          userState.account!.id,
          permission.id,
          role,
        )
        .then(_updatedRoleOk)
        .catchError(_onError);
  }

  Future<void> _removedOk(c) async {
    await _loadPermissions();
    await Loading.dismiss();
    RecToast.showSuccess(context, 'REMOVED_USER_CORRECTLY');
  }

  Future<void> _updatedRoleOk(c) async {
    await _loadPermissions();
    await Loading.dismiss();
    RecToast.showSuccess(context, 'UPDATED_USER_CORRECTLY');
  }

  void _onError(e) {
    Loading.dismiss();
    RecToast.showError(context, e.message);
  }
}
