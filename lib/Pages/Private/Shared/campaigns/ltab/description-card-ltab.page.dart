import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/accept-terms.dart';
import 'package:rec/Pages/Private/Shared/InAppBrowser.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/campaign_helper.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/config/brand.dart';

class LtabDescriptionCard extends StatefulWidget {
  final bool termsAccepted;
  final ValueChanged<bool?>? termsAcceptedChanged;

  LtabDescriptionCard({
    Key? key,
    this.termsAccepted = true,
    this.termsAcceptedChanged,
  }) : super(key: key);

  @override
  _LtabDescriptionCardState createState() => _LtabDescriptionCardState();
}

class _LtabDescriptionCardState extends State<LtabDescriptionCard> {
  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var theme = Theme.of(context);
    var localizations = AppLocalizations.of(context);
    var activeCampaign = CampaignProvider.of(context).getCampaignByCode(
      env.CMP_LTAB_CODE,
    );

    if (activeCampaign == null ||
        !CampaignHelper.isActiveForState(userState, activeCampaign) ||
        !activeCampaign.bonusEnabled) {
      return SizedBox.shrink();
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Brand.backgroundBanner,
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 60),
                child: LocalizedText(
                  'ENTER_CAMPAIGN_TITLE',
                  style: theme.textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Brand.accentColor,
                  ),
                  params: {
                    'percent': activeCampaign.percent,
                  },
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyText1!.copyWith(
                    color: Brand.accentColor,
                    height: 1.22,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(text: localizations!.translate('ENTER_CAMPAIGN')),
                    TextSpan(text: ' '),
                    TextSpan(
                      text: activeCampaign.name!.toUpperCase(),
                      recognizer: TapGestureRecognizer()..onTap = _campaignLinkTapped,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(text: ' '),
                    TextSpan(
                      text: localizations.translate(
                        'ENTER_CAMPAIGN_DESC',
                        params: {
                          'min': activeCampaign.min,
                          'max': activeCampaign.max,
                        },
                      ),
                    ),
                  ],
                ),
              ),
              AcceptTerms(
                termsAccepted: widget.termsAccepted,
                termsAcceptedChanged: widget.termsAcceptedChanged,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            width: 48,
            height: 48,
            child: Image.network(activeCampaign.imageUrl!),
          ),
        )
      ],
    );
  }

  void _campaignLinkTapped() {
    var cultureCampaign = CampaignProvider.deaf(context).getCampaignByCode(
      env.CMP_LTAB_CODE,
    );
    InAppBrowser.openLink(context, cultureCampaign!.urlTos);
  }
}
