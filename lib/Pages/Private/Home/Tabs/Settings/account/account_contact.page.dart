import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rec/Components/Inputs/text_fields/PrefixPhoneField.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/validators/validators.dart';
import 'package:rec/Pages/Private/Shared/EditField.page.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

enum ContactOption { email, phone, web }

class AccountContactPage extends StatefulWidget {
  final ContactOption? fieldToEdit;
  AccountContactPage({Key? key, this.fieldToEdit}) : super(key: key);

  @override
  _AccountContactPageState createState() => _AccountContactPageState();
}

class _AccountContactPageState extends State<AccountContactPage> {
  final AccountsService _accountsService = AccountsService(env: env);
  final DniPhoneData data = DniPhoneData();

  Map<ContactOption, Future Function()> _fieldToMethodMap = {};

  @override
  void initState() {
    super.initState();
    _fieldToMethodMap = {
      ContactOption.email: _editEmail,
      ContactOption.phone: _editPhone,
      ContactOption.web: _editWeb,
    };

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.fieldToEdit != null) {
        _fieldToMethodMap[widget.fieldToEdit]!().then((value) {
          // If we open a field directly to edit,
          // when navigating back from the edit field we must go back to the page
          // from where it was opened. If we don't do this it will go back to the
          // contact page instead.
          Navigator.pop(context);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    final userState = UserState.of(context);
    final hasEmail = Checks.isNotEmpty(userState.account!.email);
    final hasWebsite = Checks.isNotEmpty(userState.account!.webUrl);
    final hasPhone = userState.account!.phone != null && userState.account!.phone!.isNotEmpty;

    final tiles = [
      GeneralSettingsTile(
        title: hasPhone ? userState.account!.fullPhone : 'PHONE',
        subtitle: hasPhone ? 'PHONE' : 'PHONE_DESC',
        onTap: _editPhone,
      ),
      Divider(height: 1),
      GeneralSettingsTile(
        title: hasEmail ? userState.account!.email : 'EMAIL_ONLY',
        subtitle: hasEmail ? 'EMAIL_ONLY' : 'CHANGE_EMAIL',
        onTap: _editEmail,
      ),
      GeneralSettingsTile(
        title: hasWebsite ? userState.account!.webUrl : 'WEBSITE',
        subtitle: hasWebsite ? 'WEBSITE' : 'WEBSITE_DESC',
        onTap: _editWeb,
      ),
    ];

    return Scaffold(
      backgroundColor: recTheme!.defaultAvatarBackground,
      appBar: EmptyAppBar(context, title: 'BUSSINESS_CONTACT'),
      body: Scrollbar(
        thickness: 8,
        trackVisibility: true,
        radius: Radius.circular(3),
        child: ListView.builder(
          itemBuilder: (ctx, index) => tiles[index],
          itemCount: tiles.length,
        ),
      ),
    );
  }

  _editField({
    String fieldName = 'FIELD',
    FormFieldValidator<String>? validator = Validators.isRequired,
    String? initialValue,
    String? apiFieldName,
    String? hintText,
    IconData? icon,
    List<Widget>? fields,
  }) {
    var userState = UserState.of(context, listen: false);

    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EditFieldPage(
          initialValue: initialValue,
          fieldName: fieldName,
          hintText: hintText,
          icon: icon,
          validator: validator,
          fields: fields,
          onSave: (value) {
            _updateAccount(userState.account!.id, {
              (apiFieldName ?? fieldName.toLowerCase()): value,
            });
          },
        ),
      ),
    );
  }

  Future _editPhone() async {
    final userState = UserState.of(context, listen: false);
    data.phone = userState.account!.phone;
    data.prefix = userState.account!.prefix;

    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EditFieldPage(
          initialValue: userState.account!.fullPhone,
          fieldName: 'PHONE',
          icon: Icons.phone,
          validator: null,
          fields: [
            PrefixPhoneField(
              prefix: userState.account!.prefix,
              phone: userState.account!.phone,
              phoneChange: (phone) {
                data.phone = phone;
              },
              prefixChange: (prefix) {
                data.prefix = prefix;
              },
            ),
          ],
          onSave: (value) {
            final dataUnchanged = (data.phone == null && data.prefix == null) ||
                data.phone == userState.account!.phone && data.prefix == userState.account!.prefix;

            if (dataUnchanged) {
              RecToast.showInfo(context, "NOTHING_TO_UPDATE");
              return;
            }

            _updateAccount(userState.account!.id, {
              'phone': data.phone ?? userState.account!.phone,
              'prefix': data.prefix?.isEmpty == true ? '34' : data.prefix,
            });
          },
        ),
      ),
    );
  }

  Future _editEmail() async {
    var userState = UserState.of(context, listen: false);
    return _editField(
      fieldName: 'EMAIL_ONLY',
      icon: Icons.mail_outline,
      initialValue: userState.account!.email,
      validator: Validators.isEmail,
      apiFieldName: 'email',
    );
  }

  Future _editWeb() async {
    var userState = UserState.of(context, listen: false);
    return _editField(
      fieldName: 'WEBSITE',
      hintText: 'URL_MUST_START_WITH',
      icon: Icons.link,
      initialValue: userState.account!.webUrl,
      apiFieldName: 'web',
      validator: null,
    );
  }

  _updateAccount(
    String? accountId,
    Map<String, dynamic> data,
  ) {
    Loading.show();
    _accountsService.updateAccount(accountId, data).then(_updateOk).catchError(_onError);
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
