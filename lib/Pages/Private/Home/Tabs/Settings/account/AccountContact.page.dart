import 'package:flutter/material.dart';
import 'package:rec/Api/Services/AccountsService.dart';
import 'package:rec/Components/Inputs/PrefixPhoneField.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Entities/Forms/DniPhoneData.dart';
import 'package:rec/Helpers/Checks.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Helpers/Validators.dart';
import 'package:rec/Pages/Private/Shared/EditField.page.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';

class AccountContactPage extends StatefulWidget {
  AccountContactPage({Key key}) : super(key: key);

  @override
  _AccountContactPageState createState() => _AccountContactPageState();
}

class _AccountContactPageState extends State<AccountContactPage> {
  final AccountsService _accountsService = AccountsService();
  final DniPhoneData data = DniPhoneData();

  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var tiles = [
      GeneralSettingsTile(
        title: userState.account.fullPhone ?? 'PHONE',
        subtitle: 'PHONE_DESC',
        onTap: _editPhone,
      ),
      Divider(height: 1),
      GeneralSettingsTile(
        title: userState.account.email ?? 'Email',
        subtitle: 'CHANGE_EMAIL',
        onTap: _editEmail,
      ),
      GeneralSettingsTile(
        title: Checks.isNotEmpty(userState.account.webUrl)
            ? userState.account.webUrl
            : 'WEBSITE',
        subtitle: 'WEBSITE_DESC',
        onTap: _editWeb,
      ),
    ];

    return Scaffold(
      backgroundColor: Brand.defaultAvatarBackground,
      appBar: EmptyAppBar(context, title: 'SETTINGS_BUSSINESS_ON_MAP'),
      body: Scrollbar(
        thickness: 8,
        showTrackOnHover: true,
        radius: Radius.circular(3),
        child: ListView.builder(
          itemBuilder: (ctx, index) => tiles[index],
          itemCount: tiles.length,
        ),
      ),
    );
  }

  void _editField({
    String fieldName = 'FIELD',
    FormFieldValidator<String> validator = Validators.isRequired,
    String initialValue,
    String apiFieldName,
    IconData icon,
    List<Widget> fields,
  }) async {
    var userState = UserState.of(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EditFieldPage(
          initialValue: initialValue,
          fieldName: fieldName,
          icon: icon,
          validator: validator,
          fields: fields,
          onSave: (value) {
            _updateAccount(userState.account.id, {
              (apiFieldName ?? fieldName.toLowerCase()): value,
            });
          },
        ),
      ),
    );
  }

  void _editPhone() async {
    var userState = UserState.of(context, listen: false);
    data.phone = userState.account.phone;
    data.prefix = userState.account.prefix;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EditFieldPage(
          initialValue: userState.account.fullPhone,
          fieldName: 'PHONE',
          icon: Icons.phone,
          validator: null,
          fields: [
            PrefixPhoneField(
              prefix: userState.account.prefix,
              phone: userState.account.phone,
              phoneChange: (phone) {
                data.phone = phone;
              },
              prefixChange: (prefix) {
                data.prefix = prefix;
              },
              phoneValidator: Validators.phoneVerification,
            ),
          ],
          onSave: (value) {
            var dataUnchanged = (data.phone == null && data.prefix == null) ||
                data.phone == userState.account.phone &&
                    data.prefix == userState.account.prefix;

            if (dataUnchanged) {
              return Navigator.pop(context);
            }

            _updateAccount(userState.account.id, {
              'phone': data.phone ?? userState.account.phone,
              'prefix': data.prefix ?? userState.account.prefix,
            });
          },
        ),
      ),
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

  void _editWeb() async {
    var userState = UserState.of(context, listen: false);
    return _editField(
      fieldName: 'WEBSITE',
      icon: Icons.link,
      initialValue: userState.account.webUrl,
      apiFieldName: 'web',
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
