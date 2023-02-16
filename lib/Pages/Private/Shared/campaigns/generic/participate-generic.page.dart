import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Modals/YesNoModal.dart';
import 'package:rec/Components/Text/LinkText.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Text/styled_text.dart';
import 'package:rec/Components/accept-terms.dart';
import 'package:rec/Pages/Private/Shared/InAppBrowser.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/rec_preferences.dart';
import 'package:rec/providers/account_campaign_provider.dart';
import 'package:rec/providers/campaign_manager.dart';
import 'package:rec/providers/preferences/PreferenceDefinitions.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/styles/paddings.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GenericCampaignParticipatePage extends StatefulWidget {
  final bool hideDontShowAgain;
  final Campaign campaign;

  GenericCampaignParticipatePage({
    Key? key,
    this.hideDontShowAgain = false,
    required this.campaign,
  }) : super(key: key);

  @override
  _GenericCampaignParticipatePageState createState() => _GenericCampaignParticipatePageState();

  static bool isActive(BuildContext context, Campaign campaign) {
    return campaign.status == Campaign.STATUS_ACTIVE;
  }

  static bool shouldBeOpenned(BuildContext context, Campaign campaign) {
    final userState = UserState.deaf(context);
    // * Solamente debe mostrarse si el usuario tiene la cuenta particular seleccionada
    if (userState.account?.isPrivate() == false) return false;
    // No mostrar modal si el usuario no es el kyc manager de la cuenta
    if (userState.user?.isKycManager == false) return false;

    // El usuario aún no ha entrado en campaña
    final inCampaign = AccountCampaignProvider.deaf(context).getForCampaign(campaign) != null;
    if (inCampaign) return false;

    final showBanner = RecPreferences.get(PreferenceKeys.showGenericCampaign + '${campaign.id}');
    if (showBanner == false) return false;

    // La campaña esta activa (fecha actual mayot que inicial y menor que fin)
    final active = isActive(context, campaign);
    // La campaña sigue emtiendo bonificaciones (bonus_enabled = 1)
    final shouldBeOpened = campaign.bonusEnabled && active;

    return shouldBeOpened;
  }
}

class _GenericCampaignParticipatePageState extends State<GenericCampaignParticipatePage> {
  UserState? userState;
  bool termsAccepted = true;

  User? get user => userState!.user;

  @override
  void didChangeDependencies() {
    userState ??= UserState.of(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    return WillPopScope(
      onWillPop: () async {
        if (widget.hideDontShowAgain) return true;

        final yesNoModal = YesNoModal(
          context: context,
          title: LocalizedText('SHOW_AGAIN'),
          yesText: 'REMIND_LATER',
          noText: 'DONT_SHOW_AGAIN',
        );
        final res = await yesNoModal.showDialog(
          context,
        );
        if (res != null && !res) {
          _dontShowAgainChanged(true);
          return true;
        }

        return res ?? false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.maybePop(context);
              },
            )
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16).copyWith(bottom: 28, top: 90),
                child: LocalizedText(
                  'CAMPAIGN_PARTICIPATE_TITLE',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.start,
                  params: {
                    'percent': widget.campaign.percent,
                  },
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: recTheme?.gradientPrimary,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: _content(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 32),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AcceptTerms(
                          termsAccepted: termsAccepted,
                          termsAcceptedChanged: termsAcceptedChanged,
                          openTermsOfService: () {
                            InAppBrowser.openLink(context, widget.campaign.urlTos);
                          },
                          color: RecTheme.of(context)!.primaryColor,
                        ),
                        RecActionButton(
                          padding: Paddings.button.copyWith(top: 0),
                          label: 'PARTICIPATE',
                          onPressed: !termsAccepted ? null : _participate,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _content() {
    final recTheme = RecTheme.of(context);
    final hasVideo =
        widget.campaign.videoPromoUrl != null && widget.campaign.videoPromoUrl!.isNotEmpty;
    final hasPromoUrl = widget.campaign.promoUrl != null && widget.campaign.promoUrl!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasVideo) _video(),
          if (hasVideo) SizedBox(height: 16),
          LocalizedText(
            'CAMPAIGN_HOW_TO_PARTICIPATE',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: recTheme!.primaryColor,
            ),
          ),
          SizedBox(height: 8),
          LocalizedStyledText(
            'CAMPAIGN_HOW_TO_PARTICIPATE_DESC',
            style: TextStyle(height: 1.3),
            params: {
              "campaign": widget.campaign.name != null && widget.campaign.name!.isNotEmpty
                  ? " ${widget.campaign.name}"
                  : "",
            },
          ),
          if (hasPromoUrl) SizedBox(height: 8),
          if (hasPromoUrl)
            LinkText(
              'GOTO_CAMPAIGN_WEB',
              onTap: () {
                InAppBrowser.openLink(context, widget.campaign.promoUrl);
              },
            ),
        ],
      ),
    );
  }

  void _dontShowAgainChanged(bool value) async {
    await RecPreferences.setBool(
        PreferenceKeys.showGenericCampaign + '${widget.campaign.id}', !value);
  }

  void _participate() async {
    final campaignManager = CampaignManager.deaf(context);
    final accountCampaignProvider = AccountCampaignProvider.deaf(context);
    final definition = campaignManager.getDefinition('generic');

    try {
      await Loading.show();
      await userState?.userService.acceptCampaignTos(widget.campaign.code!);
      await userState?.getUser();
      await accountCampaignProvider.load();
      await Loading.dismiss();

      await RecNavigation.replace(
        context,
        (c) => definition?.welcomeBuilder(context, {}, widget.campaign),
      );
    } catch (err) {
      RecToast.showError(
        context,
        err.toString(),
      );
    }
  }

  _video() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.campaign.videoPromoUrl,
            ),
          ),
        ),
      ),
    );
  }

  void termsAcceptedChanged(bool? value) {
    termsAccepted = value ?? false;
    setState(() {});
    _dontShowAgainChanged(false);
  }
}
