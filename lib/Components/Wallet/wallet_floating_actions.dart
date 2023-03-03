import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/roles_definitions.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/config/routes.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class WalletFloatingActions extends StatefulWidget {
  final TextStyle labelStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    // color: Brand.grayDark,
  );
  final ValueNotifier<bool> isDialOpen;

  WalletFloatingActions({Key? key, required this.isDialOpen}) : super(key: key);

  @override
  WalletFloatingActionsState createState() => WalletFloatingActionsState();
}

class WalletFloatingActionsState extends State<WalletFloatingActions> {
  @override
  Widget build(BuildContext context) {
    return buildSpeedDial();
  }

  Widget buildSpeedDial() {
    final userState = UserState.of(context);
    final recTheme = RecTheme.of(context);

    final campaignProvider = CampaignProvider.of(context);
    final account = userState.account;
    final user = userState.user;
    final cultureCampaign = campaignProvider.getCampaignByCode(env.CMP_CULT_CODE);

    final isPrivate = account!.isPrivate();
    final accountTypeColor = recTheme!.accountTypeColor(account.type ?? Account.TYPE_PRIVATE);
    final isLtabAccount = account.isLtabAccount();
    final isCultureAccount = account.isCampaignAccount(env.CMP_CULT_CODE);

    final hasPermissionToRecharge = user!.hasRoles(RoleDefinitions.rechargeRoles);
    final hasPermissionToPay = user.hasRoles(RoleDefinitions.payButton);
    final hasPermissionToPayQr = user.hasRoles(RoleDefinitions.payQrButton);
    final hasPermissionToCharge = user.hasRoles(RoleDefinitions.chargeButton);

    final isCultureCampaignActive =
        cultureCampaign != null && cultureCampaign.isStarted() && !cultureCampaign.isFinished();
    final rechargeRoute =
        isCultureAccount || !isCultureCampaignActive || !cultureCampaign!.bonusEnabled
            ? Routes.recharge
            : Routes.selectRecharge;

    final privateChildren = [
      if (hasPermissionToPay)
        buildSpeedDialChild(
          'PAY_QR',
          Icons.qr_code_scanner,
          context,
          bgColor: accountTypeColor,
          route: Routes.payQr,
        ),
      if (hasPermissionToPayQr)
        buildSpeedDialChild(
          'PAY_ACCOUNT',
          Icons.call_made,
          context,
          bgColor: accountTypeColor,
          route: Routes.payContactAccount,
        ),
      if (!isLtabAccount && hasPermissionToCharge)
        buildSpeedDialChild(
          'RECEIVE_PAYMENT',
          Icons.call_received,
          context,
          bgColor: accountTypeColor,
          route: Routes.charge,
        ),
      if (!isLtabAccount && hasPermissionToRecharge)
        buildSpeedDialChild(
          'RECHARGE_RECS',
          Icons.credit_card,
          context,
          iconColor: recTheme.grayDark,
          bgColor: recTheme.defaultAvatarBackground,
          route: rechargeRoute,
        ),
    ];

    final companyChildren = [
      if (hasPermissionToCharge)
        buildSpeedDialChild(
          'CHARGE',
          Icons.call_received,
          context,
          bgColor: accountTypeColor,
          route: Routes.charge,
        ),
      if (hasPermissionToPayQr)
        buildSpeedDialChild(
          'PAY_QR',
          Icons.qr_code_scanner,
          context,
          bgColor: accountTypeColor,
          route: Routes.payQr,
        ),
      if (hasPermissionToPay)
        buildSpeedDialChild(
          'PAY_ACCOUNT',
          Icons.call_made,
          context,
          bgColor: accountTypeColor,
          route: Routes.payContactAccount,
        ),
      if (hasPermissionToRecharge)
        buildSpeedDialChild(
          'RECHARGE_RECS',
          Icons.credit_card,
          context,
          iconColor: recTheme.grayDark,
          bgColor: recTheme.defaultAvatarBackground,
          route: rechargeRoute,
        ),
    ];

    final List<SpeedDialChild?> items = (isPrivate ? privateChildren : companyChildren);

    if (items.isEmpty) return SizedBox.shrink();

    return SpeedDial(
      openCloseDial: widget.isDialOpen,
      animationSpeed: 150,
      buttonSize: 60,
      icon: Icons.multiple_stop,
      activeIcon: Icons.close,
      iconTheme: IconThemeData(color: Colors.white, size: 30),
      visible: true,
      curve: Curves.linear,
      overlayColor: Colors.white,
      overlayOpacity: 0.9,
      backgroundColor: accountTypeColor,
      foregroundColor: Colors.white,
      elevation: 0,
      children: items as List<SpeedDialChild>,
    );
  }

  SpeedDialChild buildSpeedDialChild(
    String label,
    IconData icon,
    BuildContext context, {
    Color? bgColor,
    Color iconColor = Colors.white,
    String? route,
  }) {
    final recTheme = RecTheme.of(context);

    return SpeedDialChild(
      child: Icon(
        icon,
        color: iconColor,
      ),
      backgroundColor: bgColor ?? recTheme!.primaryColor,
      labelWidget: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: LocalizedText(
          label,
          style: widget.labelStyle.copyWith(fontWeight: FontWeight.w400),
        ),
      ),
      elevation: 0,
      onTap: () {
        if (route != null) Navigator.of(context).pushNamed(route);
      },
    );
  }
}
