import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/accept-terms.dart';
import 'package:rec/Components/info-box.dart';
import 'package:rec/Pages/Private/Shared/InAppBrowser.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/campaign_provider.dart';

class CultureInfoBox extends StatelessWidget {
  final ValueChanged<bool?> termsAcceptedChanged;
  final bool termsAccepted;

  const CultureInfoBox({
    Key? key,
    required this.termsAcceptedChanged,
    this.termsAccepted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var activeCampaign = CampaignProvider.of(context).getCampaignByCode(
      env.CMP_CULT_CODE,
    );

    return InfoBox(
      backgroundColor: Brand.backgroundBannerCulture,
      children: [
        LocalizedText(
          'CULTURE_PARTICIPATE_INFO_TITLE',
          style: theme.textTheme.subtitle1!.copyWith(
            fontWeight: FontWeight.w500,
            color: Brand.grayDark,
          ),
          params: {
            'percent': activeCampaign!.percent,
          },
        ),
        LocalizedText(
          'CULTURE_PARTICIPATE_INFO_DESCRIPTION',
          params: {
            'percent': activeCampaign.percent,
          },
        ),
        AcceptTerms(
          termsAccepted: termsAccepted,
          termsAcceptedChanged: termsAcceptedChanged,
          openTermsOfService: () {
            var cultureCampaign = CampaignProvider.deaf(context).getCampaignByCode(
              env.CMP_LTAB_CODE,
            );
            InAppBrowser.openLink(context, cultureCampaign!.urlTos);
          },
        ),
      ],
    );
  }
}
