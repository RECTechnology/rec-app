import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/info_box.dart';
import 'package:rec/config/brand.dart';
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
    var theme = Theme.of(context);
    var ltabCampaign = CampaignProvider.of(context).getCampaignByCode(env.CMP_LTAB_CODE);

    return InfoBox(
      backgroundColor: Brand.defaultAvatarBackground,
      children: [
        LocalizedText(
          'LTAB_PARTICIPATE_INFO_TITLE',
          style: theme.textTheme.subtitle1!.copyWith(
            fontWeight: FontWeight.w500,
            color: Brand.grayDark,
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
