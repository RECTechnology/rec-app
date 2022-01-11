import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Shared/InAppBrowser.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/CampaignProvider.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';

class CampaignDescriptionCard extends StatefulWidget {
  final bool termsAccepted;
  final ValueChanged<bool> termsAcceptedChanged;

  CampaignDescriptionCard({
    Key key,
    this.termsAccepted = true,
    this.termsAcceptedChanged,
  }) : super(key: key);

  @override
  _CampaignDescriptionCardState createState() => _CampaignDescriptionCardState();
}

class _CampaignDescriptionCardState extends State<CampaignDescriptionCard> {
  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var theme = Theme.of(context);
    var localizations = AppLocalizations.of(context);
    var activeCampaign = CampaignProvider.of(context).activeCampaign;

    if (activeCampaign == null ||
        !activeCampaign.isActiveForState(userState) ||
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
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LocalizedText(
                'ENTER_CAMPAIGN_TITLE',
                style: theme.textTheme.subtitle1.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Brand.accentColor,
                ),
                params: {
                  'percent': activeCampaign.percent,
                },
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyText1.copyWith(
                    color: Brand.accentColor,
                    height: 1.22,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(text: localizations.translate('ENTER_CAMPAIGN')),
                    TextSpan(text: ' '),
                    TextSpan(
                      text: activeCampaign.name.toUpperCase(),
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
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: widget.termsAccepted,
                    onChanged: widget.termsAcceptedChanged,
                    checkColor: Colors.white,
                    activeColor: Brand.accentColor,
                  ),
                  LocalizedText(
                    'I_ACCEPT_THE',
                    style: theme.textTheme.bodyText1.copyWith(
                      color: Brand.accentColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: _openTermsOfService,
                    child: LocalizedText(
                      'TERMS_OF_SERVICE',
                      style: theme.textTheme.bodyText1.copyWith(
                        decoration: TextDecoration.underline,
                        color: Brand.accentColor,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: Container(
            width: 48,
            height: 48,
            child: Image.network(activeCampaign.imageUrl),
          ),
        )
      ],
    );
  }

  void _campaignLinkTapped() {
    var link = AppLocalizations.of(context).translate('link_ltab');
    InAppBrowser.openLink(context, link);
  }

  void _openTermsOfService() {
    var link = AppLocalizations.of(context).translate('link_ltab_tos');
    InAppBrowser.openLink(context, link);
  }
}
