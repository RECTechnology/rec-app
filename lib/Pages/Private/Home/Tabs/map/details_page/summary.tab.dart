import 'package:flutter/material.dart';
import 'package:rec/Components/Info/aspect_ratio_image.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Text/ReadMoreText.dart';
import 'package:rec/Pages/Private/Home/Tabs/map/details_page/widgets/badge_section.dart';
import 'package:rec/Pages/Private/Home/Tabs/map/details_page/widgets/sumary_filter_buttons.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/helpers/BrowserHelper.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class SummaryTab extends StatelessWidget {
  SummaryTab(this.account, {Key? key, this.scrollController}) : super(key: key);

  final Account account;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    final hasDescription = account.description!.isNotEmpty;
    final hasWeb = account.hasWeb();
    final hasPublicImage = account.hasPublicImage();
    final hasEmail = account.hasEmail();
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
                SizedBox(height: 16),
                if (account.address?.streetName != null)
                  Wrap(children: [
                    Icon(
                      Icons.place_rounded,
                      color: recTheme?.grayLight,
                    ),
                    SizedBox(width: 5),
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      child: LocalizedText(
                        account.addressString!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: recTheme?.grayDark,
                        ),
                      ),
                    ),
                  ]),
                if (hasEmail) _buildEmailLink(context),
                if (hasEmail) SizedBox(height: 16),
                if (hasWeb) _buildWebLink(),
                if (hasWeb) SizedBox(height: 16),
                if (hasDescription) _buildDescription(context),
                SizedBox(height: 16),
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
    return Builder(
      builder: (context) {
        final recTheme = RecTheme.of(context);

        return InkWell(
          onTap: _launchWeb,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 16),
            child: Wrap(
              children: [
                Icon(
                  Icons.link_outlined,
                  color: recTheme?.grayLight,
                ),
                SizedBox(width: 5),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Text(
                    account.webUrl ?? '',
                    style: recTheme!.textTheme.link,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  _buildEmailLink(BuildContext context) {
    final recTheme = RecTheme.of(context);
    return Wrap(children: [
      Icon(
        Icons.email,
        color: recTheme?.grayLight,
      ),
      SizedBox(width: 5),
      Container(
        margin: EdgeInsets.only(top: 4),
        child: LocalizedText(
          account.email!,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: recTheme?.grayDark,
          ),
        ),
      ),
    ]);
  }
}
