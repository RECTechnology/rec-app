import 'package:flutter/material.dart';
import 'package:rec/Components/Info/rec_circle_avatar.dart';
import 'package:rec/Components/ListTiles/SectionTitleTile.dart';
import 'package:rec/Components/ListTiles/campaign_list_tile.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/providers/campaign_manager.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class CampaignsSettingsList extends StatelessWidget {
  CampaignsSettingsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var campaignProvider = CampaignProvider.of(context);
    var campaignManager = CampaignManager.of(context);
    var localizations = AppLocalizations.of(context);
    var userState = UserState.of(context);

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

    var allCampaigns = campaignProvider.campaigns!
        .where((element) =>
            element!.isStarted() &&
            !element.isFinished() &&
            (element.bonusEnabled || !element.bonusEnabled && userInCampaign))
        .toList();

    if (allCampaigns.isEmpty) return SizedBox.shrink();

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
              var builder = definition.hasAcceptedTOS(context)
                  ? definition.welcomeBuilder
                  : definition.participateBuilder;

              RecNavigation.of(context).navigate(
                (c) => builder(context, {'hideDontShowAgain': true}),
              );
            },
            leading: CircleAvatarRec.withImageUrl(
              campaign.imageUrl,
              name: campaign.name,
            ),
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
                  (c) => definition.welcomeBuilder(context, {'hideDontShowAgain': true}),
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
