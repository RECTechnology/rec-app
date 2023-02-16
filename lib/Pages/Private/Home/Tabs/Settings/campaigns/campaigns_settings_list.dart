import 'package:flutter/material.dart';
import 'package:rec/Components/Info/rec_circle_avatar.dart';
import 'package:rec/Components/ListTiles/SectionTitleTile.dart';
import 'package:rec/Components/ListTiles/campaign_list_tile.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/providers/account_campaign_provider.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/providers/campaign_manager.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class CampaignsSettingsList extends StatelessWidget {
  CampaignsSettingsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final campaignProvider = CampaignProvider.of(context);
    final campaignManager = CampaignManager.of(context);
    final localizations = AppLocalizations.of(context);
    final userState = UserState.of(context);
    final recTheme = RecTheme.of(context);
    final accountCampaigns = AccountCampaignProvider.of(context);

    var account = userState.account;
    var user = userState.user;

    if (campaignProvider.loading) {
      return Center(child: CircularProgressIndicator());
    }

    var isLtabAccount = account!.isCampaignAccount(env.CMP_LTAB_CODE);
    var isCultureAccount = account.isCampaignAccount(env.CMP_CULT_CODE);
    var userInCampaign = user!.hasCampaignAccount(env.CMP_LTAB_CODE);

    // This is here so we don't show all campaigns if the current account is a campaign account
    if (isLtabAccount) {
      return _renderOneCampaign(
        campaignProvider.getCampaignByCode(env.CMP_LTAB_CODE),
      );
    }

    if (isCultureAccount) {
      return _renderOneCampaign(
        campaignProvider.getCampaignByCode(env.CMP_CULT_CODE),
      );
    }

    final allCampaigns = campaignProvider.campaigns!
        .where((element) =>
            element!.isStarted() &&
            !element.isFinished() &&
            (element.bonusEnabled || !element.bonusEnabled && userInCampaign))
        .toList();
        
    final v2Campaigns = campaignProvider.campaignsV2!.where((element) {
      final inCampaign = accountCampaigns.getForCampaign(element) != null;

      return element?.status == Campaign.STATUS_ACTIVE &&
          account.isPrivate() &&
          (element!.bonusEnabled || !element.bonusEnabled && inCampaign);
    }).toList();

    if (allCampaigns.isEmpty && v2Campaigns.isEmpty) return SizedBox.shrink();

    return Column(
      children: [
        SectionTitleTile('CAMPAIGNS'),
        ...allCampaigns.map((campaign) {
          // TODO: This is temporal, will be removed when we host translations on the server
          var title = '${campaign!.code}_WITH_NEIGHBORHOODS';
          var description = localizations!.translate(
            '${campaign.code}_DESC',
            params: {'percent': campaign.percent},
          );

          return CampaignsListTile(
            campaign: campaign,
            title: title,
            description: description,
            onTap: () {
              var definition = campaignManager.getDefinition(campaign.code!);
              if (definition == null) return;

              // Aqui tenemos que seleccionar una pantalla u otra dependiendo de
              // si ya participan en la campaña o no, si participan les llevamos a la pantalla de bienvenida
              // si no participan les llevamos a la pantalla de participar en la campaña
              var builder = definition.hasAcceptedTOS(context, campaign)
                  ? definition.welcomeBuilder
                  : definition.participateBuilder;

              RecNavigation.of(context).navigate(
                (c) => builder(context, {'hideDontShowAgain': true}, campaign),
              );
            },
            leading: CircleAvatarRec.withImageUrl(
              campaign.imageUrl,
              name: campaign.name,
            ),
          );
        }),
        ...v2Campaigns.map((campaign) {
          final inCampaign = accountCampaigns.getForCampaign(campaign) != null;
          final image = campaign?.imageUrl == null || campaign?.imageUrl == ''
              ? Image.asset(recTheme!.assets.logo)
              : CircleAvatarRec.withImageUrl(
                  campaign!.imageUrl,
                  name: campaign.name,
                );

          return CampaignsListTile(
            campaign: campaign,
            title: campaign!.name == null || campaign.name!.isEmpty ? 'CAMPAIGN' : campaign.name,
            description:
                campaign.description ?? (inCampaign ? 'ALREADY_IN_CAMPAIGN' : 'NOT_IN_CAMPAIGN'),
            onTap: () {
              var definition = campaignManager.getDefinition('generic');
              if (definition == null) return;

              // Aqui tenemos que seleccionar una pantalla u otra dependiendo de
              // si ya participan en la campaña o no, si participan les llevamos a la pantalla de bienvenida
              // si no participan les llevamos a la pantalla de participar en la campaña
              final hasAccepted = definition.hasAcceptedTOS(context, campaign);
              final builder =
                  hasAccepted ? definition.welcomeBuilder : definition.participateBuilder;

              RecNavigation.of(context).navigate(
                (c) => builder(context, {'hideDontShowAgain': true}, campaign),
              );
            },
            leading: image,
          );
        }),
      ],
    );
  }

  Widget _renderOneCampaign(Campaign? campaign) {
    return Column(
      children: [
        SectionTitleTile('CAMPAIGN'),
        Builder(
          builder: (context) {
            // TODO: This is temporal, will be removed when we host translations on the server
            var title = '${campaign!.code}_WITH_NEIGHBORHOODS';

            return CampaignsListTile(
              campaign: campaign,
              title: title,
              onTap: () {
                var campaignManager = CampaignManager.deaf(context);
                var definition = campaignManager.getDefinition(campaign.code!);
                if (definition == null) return;

                RecNavigation.of(context).navigate(
                  (c) => definition.welcomeBuilder(context, {'hideDontShowAgain': true}, campaign),
                );
              },
              leading: CircleAvatarRec(
                imageUrl: campaign.imageUrl,
                name: campaign.name,
              ),
            );
          },
        ),
      ],
    );
  }
}
