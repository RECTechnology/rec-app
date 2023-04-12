import 'package:flutter/material.dart';
import 'package:rec/Components/Info/rec_circle_avatar.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Modals/YesNoModal.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/boxes.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/account/account_contact.page.dart';
import 'package:rec/config/routes.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ConnectaServiceActive extends StatefulWidget {
  ConnectaServiceActive({Key? key}) : super(key: key);

  @override
  State<ConnectaServiceActive> createState() => _ConnectaServiceActiveState();
}

class _ConnectaServiceActiveState extends State<ConnectaServiceActive> {
  final AccountsService _accountsService = AccountsService(env: env);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EmptyAppBar(
        context,
        title: 'CONNECT_TITLE',
        actions: [_popupMenu()],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    _comerceInfo(),
                    const SizedBox(height: 32),
                    _boxes(),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: RecActionButton(
              label: 'ASK_REPORT',
              onPressed: _askReport,
              backgroundColor: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  _popupMenu() {
    return PopupMenuButton<int>(
      initialValue: 0,
      icon: Icon(Icons.more_vert, color: Colors.black),
      onSelected: (int item) {
        switch (item) {
          case 0:
            _deactivateService();
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 0,
          child: LocalizedText('DEACTIVATE_SERVICE'),
        ),
      ],
    );
  }

  _deactivateService() async {
    final theme = RecTheme.of(context);
    final yesNoModal = YesNoModal(
      context: context,
      title: LocalizedText('DEACTIVATE_SERVICE_DIALOG_TITLE'),
      content: LocalizedText('DEACTIVATE_SERVICE_DIALOG_DESC'),
      yesText: 'DEACTIVATE',
      noText: 'CANCEL',
      yesTextColor: theme?.red,
    );
    final res = await yesNoModal.showDialog(context);
    if (res != null && res) {
      _deactivateProducts();
    }
  }

  void _deactivateProducts() async {
    final id = UserState.deaf(context).account!.id;
    try {
      Loading.show();
      await _accountsService.deactivateB2BProductsForAccount(id);
      await UserState.deaf(context).getUser();
      Navigator.pushReplacementNamed(context, Routes.settingsConnectaInactive);
    } catch (e) {
      RecToast.showError(context, e.toString());
    }
    Loading.dismiss();
  }

  _boxes() {
    final recTheme = RecTheme.of(context);
    final style = TextStyle(color: Colors.white);

    return Column(
      children: [
        GradientBox(
          onTap: () => RecNavigation.navigateToRoute(context, Routes.settingsConnectaConsuming),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocalizedText(
                      'CONSUMING',
                      style: style.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LocalizedText(
                      'CONSUMING_DESC',
                      style: style.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.trending_down, color: Colors.white, size: 48),
            ],
          ),
        ),
        const SizedBox(height: 32),
        GradientBox(
          onTap: () => RecNavigation.navigateToRoute(context, Routes.settingsConnectaProducing),
          gradient: recTheme?.gradientSecondary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocalizedText(
                      'PRODUCING',
                      style: style.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LocalizedText(
                      'PRODUCING_DESC',
                      style: style.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.trending_up, color: Colors.white, size: 48),
            ],
          ),
        ),
      ],
    );
  }

  _comerceInfo() {
    final account = UserState.of(context).account;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          child: CircleAvatarRec.fromAccount(account!),
          width: 80,
          height: 80,
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LocalizedText(
                account.name!,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 4),
              LocalizedText(
                account.phone!,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
              LocalizedText(
                account.email!,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
              LocalizedText(
                account.webUrl!,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _askReport() async {
    final account = UserState.deaf(context).account;
    if (!account!.hasEmail()) {
      // Show warning and take user to settings -> email
      final yesNoModal = YesNoModal(
        context: context,
        title: LocalizedText('NO_EMAIL'),
        content: LocalizedText('NO_EMAIL_DESC'),
        yesText: 'CHANGE_EMAIL',
        noText: 'CANCEL',
      );
      final res = await yesNoModal.showDialog(context);
      if (res != null && res) {
        var hasChangedEmail = await _goToChangeEmail();
        if (hasChangedEmail) _sendReport();
      }
    } else {
      _sendReport();
    }
  }

  Future<bool> _goToChangeEmail() async {
    await RecNavigation.navigate(
      context,
      (context) => AccountContactPage(
        fieldToEdit: ContactOption.email,
      ),
    );
    await UserState.deaf(context).getUser();
    return UserState.deaf(context).account!.hasEmail();
  }

  void _sendReport() {
    RecToast.show(context, 'SEND_REPORT');
  }
}
