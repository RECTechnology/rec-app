import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Api/Services/AccountsService.dart';
import 'package:rec/Components/ListTiles/SectionTitleTile.dart';
import 'package:rec/Components/Map/BussinessHeader.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';

import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Helpers/Validators.dart';
import 'package:rec/Pages/Private/Shared/EditField.page.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';

class MyAccountPage extends StatefulWidget {
  MyAccountPage({Key key}) : super(key: key);

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final AccountsService _accountsService = AccountsService();

  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var tiles = [
      GeneralSettingsTile(
        title: userState.account.name ?? 'NAME',
        subtitle: 'ACCOUNT_NAME',
        onTap: _editName,
      ),
      GeneralSettingsTile(
        title: userState.account.email ?? 'Email',
        subtitle: 'CHANGE_EMAIL',
        onTap: _editEmail,
      ),
    ];

    return Scaffold(
      backgroundColor: Brand.defaultAvatarBackground,
      appBar: EmptyAppBar(context, title: 'SETTINGS_MY_ACCOUNT'),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: BussinessHeader(
              userState.account,
              avatarBadge: Positioned(
                bottom: -8,
                right: -4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkResponse(
                    onTap: () {
                      print('tappppped');
                    },
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Brand.primaryColor,
                      ),
                      child: Icon(Icons.add_a_photo,
                          color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SectionTitleTile('YOUR_ACCOUNT'),
          Expanded(
            child: Scrollbar(
              thickness: 8,
              showTrackOnHover: true,
              radius: Radius.circular(3),
              child: ListView.separated(
                itemBuilder: (ctx, index) => tiles[index],
                separatorBuilder: (ctx, index) => Divider(height: 1),
                itemCount: tiles.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editField({
    String fieldName = 'FIELD',
    FormFieldValidator<String> validator = Validators.isRequired,
    String initialValue,
    IconData icon,
  }) async {
    var userState = UserState.of(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EditFieldPage(
          initialValue: initialValue,
          fieldName: fieldName,
          icon: icon,
          validator: validator,
          onSave: (value) {
            _updateAccount(userState.account.id, {
              fieldName.toLowerCase(): value,
            });
          },
        ),
      ),
    );
  }

  void _editName() async {
    var userState = UserState.of(context, listen: false);

    return _editField(
      fieldName: 'NAME',
      icon: Icons.person,
      initialValue: userState.account.name,
      validator: Validators.isRequired,
    );
  }

  void _editEmail() async {
    var userState = UserState.of(context, listen: false);
    return _editField(
      fieldName: 'EMAIL_ONLY',
      icon: Icons.mail_outline,
      initialValue: userState.account.email,
      validator: Validators.isEmail,
    );
  }

  void _updateAccount(
    String accountId,
    Map<String, dynamic> data,
  ) {
    Loading.show();
    _accountsService
        .updateAccount(accountId, data)
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
