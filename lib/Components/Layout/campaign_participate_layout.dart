import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/blured_image_container.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/styles/paddings.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CampaignParticipateLayout extends StatelessWidget {
  const CampaignParticipateLayout({
    Key? key,
    required this.campaignCode,
    required this.onClose,
    required this.onParticipate,
    required this.dontShowAgain,
    required this.dontShowAgainChanged,
    required this.image,
    this.infoChild,
    this.hideDontShowAgain = false,
    this.buttonLabel = 'PARTICIPATE',
  }) : super(key: key);

  final void Function() onClose;
  final void Function()? onParticipate;

  final ImageProvider<Object> image;
  final String campaignCode;
  final String buttonLabel;
  final bool? dontShowAgain;
  final bool hideDontShowAgain;
  final ValueChanged<bool?> dontShowAgainChanged;

  final Widget? infoChild;

  @override
  Widget build(BuildContext context) {
    var campaignProvider = CampaignProvider.of(context);
    var campaign = campaignProvider.getCampaignByCode(campaignCode);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: EmptyAppBar(
        context,
        backArrow: false,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Brand.grayDark),
            onPressed: onClose,
          ),
        ],
      ),
      body: BluredImageContainer(
        image: image,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LocalizedText(
              'CAMPAIGN_BANNER_TITLE',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Brand.grayDark,
                    fontWeight: FontWeight.w400,
                    fontSize: 26,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              campaign!.name!.toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Brand.grayDark,
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                  ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: campaign.videoPromoUrl,
                  ),
                ),
              ),
            ),
            if (infoChild != null) infoChild!,
            const SizedBox(height: 8),
            Column(
              children: [
                if (!hideDontShowAgain)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: !(dontShowAgain ?? true),
                        onChanged: dontShowAgainChanged,
                      ),
                      LocalizedText('DONT_SHOW_AGAIN'),
                    ],
                  ),
                if (hideDontShowAgain) SizedBox(height: 48),
                RecActionButton(
                  padding: Paddings.button.copyWith(top: 0),
                  label: (dontShowAgain == false && !hideDontShowAgain) ? 'CLOSE' : buttonLabel,
                  onPressed:
                      (dontShowAgain == false && !hideDontShowAgain) ? onClose : onParticipate,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
