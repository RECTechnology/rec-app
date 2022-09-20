import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/info_box.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/campaign_provider.dart';

class LtabInfoBox extends StatelessWidget {
  final ValueChanged<bool?> termsAcceptedChanged;
  final bool termsAccepted;

  const LtabInfoBox({
    Key? key,
    required this.termsAcceptedChanged,
    this.termsAccepted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recTheme = RecTheme.of(context);
    final ltabCampaign = CampaignProvider.of(context).getCampaignByCode(env.CMP_LTAB_CODE);

    return InfoBox(
      backgroundColor: recTheme!.defaultAvatarBackground,
      children: [
        LocalizedText(
          'LTAB_PARTICIPATE_INFO_TITLE',
          style: theme.textTheme.subtitle1!.copyWith(
            fontWeight: FontWeight.w500,
            color: recTheme.grayDark,
          ),
          params: {
            'percent': ltabCampaign!.percent,
          },
        ),
        LocalizedText(
          'LTAB_PARTICIPATE_INFO_DESCRIPTION',
           params: {
            'percent': ltabCampaign.percent,
            'min': ltabCampaign.min,
            'max': ltabCampaign.max,
          },
        ),
      ],
    );
  }
}
