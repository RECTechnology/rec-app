import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rec/Components/Info/aspect_ratio_image.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Text/ReadMoreText.dart';
import 'package:rec/Pages/Private/Home/Tabs/map/details_page/widgets/badge_section.dart';
import 'package:rec/Pages/Private/Home/Tabs/map/details_page/widgets/sumary_filter_buttons.dart';
import 'package:rec/helpers/BrowserHelper.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/styles/text_styles.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class SummaryTab extends StatelessWidget {
  SummaryTab(this.account, {Key? key, this.scrollController}) : super(key: key);

  final Account account;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final hasDescription = account.description!.isNotEmpty;
    final hasWeb = account.hasWeb();
    final hasPublicImage = account.hasPublicImage();
    final hasBadges = account.badges.isNotEmpty == true;

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryFilterButtons(account: account),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocalizedText(
                  account.schedule!.getStateNameForDate(DateTime.now()),
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 16),
                if (hasDescription) _buildDescription(context),
                if (hasWeb) _buildWebLink(),
                if (hasPublicImage) _buildPublicImage(),
                if (hasBadges) BadgeSection(badges: account.badges),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return ReadMoreText(
      data: '"${account.description!.trim()}"',
      trimCollapsedText: localizations!.translate('SHOW_MORE'),
      trimExpandedText: localizations.translate('SHOW_LESS'),
    );
  }

  Widget _buildWebLink() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16),
      child: RichText(
        text: TextSpan(
          style: TextStyles.link,
          text: account.webUrl ?? '',
          recognizer: TapGestureRecognizer()..onTap = _launchWeb,
        ),
      ),
    );
  }

  Widget _buildPublicImage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: AspectRatioImage(
        image: NetworkImage(
          account.publicImage ?? 'https://picsum.photos/250?image=9',
        ),
        aspectRatio: 16 / 9,
      ),
    );
  }

  void _launchWeb() {
    BrowserHelper.openBrowser(account.webUrl);
  }
}
