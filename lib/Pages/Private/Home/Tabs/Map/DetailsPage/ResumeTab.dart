import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rec/Components/Lists/OffersList.dart';
import 'package:rec/Components/ReadMoreText.dart';
import 'package:rec/Components/RecFilterButton.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/Schedule/Schedule.ent.dart';
import 'package:rec/Helpers/BrowserHelper.dart';
import 'package:rec/Helpers/ScheduleHelper.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/brand.dart';

class ResumeTab extends StatefulWidget {
  final Account account;

  ResumeTab(this.account, {Key key}) : super(key: key);

  @override
  _ResumeTabState createState() => _ResumeTabState();
}

class _ResumeTabState extends State<ResumeTab> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var filterButtons = <RecFilterButton>[
      RecFilterButton(
        icon: Icons.call_made,
        label: localizations.translate('PAY'),
        padding: Paddings.filterButton,
        onPressed: () {},
        disabled: false,
        backgroundColor: Brand.primaryColor,
        textColor: Colors.white,
        iconColor: Colors.white,
      ),
      RecFilterButton(
        icon: Icons.assistant_direction,
        label: localizations.translate('HOW_TO_GO'),
        padding: Paddings.filterButton,
        onPressed: _launchMapsUrl,
        disabled: false,
        backgroundColor: Colors.white,
        textColor: Brand.grayDark,
        iconColor: Brand.grayDark,
      ),
      RecFilterButton(
        icon: Icons.phone,
        label: localizations.translate('CALL'),
        padding: Paddings.filterButton,
        onPressed: _call,
        disabled: false,
        backgroundColor: Colors.white,
        textColor: Brand.grayDark,
        iconColor: Brand.grayDark,
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(children: filterButtons),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        localizations.translate(
                          widget.account.schedule.getTodayStateString(
                            DateTime.now(),
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        _getNextScheduleState(),
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ReadMoreText(
                    data: ('"${widget.account.description}"'),
                    colorClickableText: Brand.grayDark,
                    style: TextStyle(
                      color: Brand.grayDark,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                    lessStyle: TextStyle(
                      color: Brand.grayDark,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                    ),
                    moreStyle: TextStyle(
                      color: Brand.grayDark,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                    ),
                    trimCollapsedText: localizations.translate('SHOW_MORE'),
                    trimExpandedText: localizations.translate('SHOW_LESS'),
                  ),
                ),
                if (widget.account.webUrl != null &&
                    widget.account.webUrl.isNotEmpty)
                  SizedBox(height: 16),
                if (widget.account.webUrl != null &&
                    widget.account.webUrl.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyles.link,
                        text: widget.account.webUrl ?? '',
                        recognizer: TapGestureRecognizer()..onTap = _launchWeb,
                      ),
                    ),
                  ),
                SizedBox(height: 16),
                if (widget.account.publicImage != null &&
                    widget.account.publicImage.isNotEmpty)
                  Container(
                    width: 380,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Brand.defaultAvatarBackground,
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          widget.account.publicImage ??
                              'https://picsum.photos/250?image=9',
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 16),
              ],
            ),
          ),
          ...(widget.account.hasOffers()
              ? [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      'Ofertas',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Brand.grayDark,
                          ),
                    ),
                  ),
                  SizedBox(height: 8),
                  OffersList(offers: widget.account.offers),
                  SizedBox(height: 8),
                ]
              : []),
        ],
      ),
    );
  }

  String _getNextScheduleState() {
    var now = DateTime.now();
    var state = widget.account.schedule.getTodayState(now);
    var localizations = AppLocalizations.of(context);

    if (state == ScheduleState.notAvailable) return '';
    if (state == ScheduleState.open) {
      var closeDate = widget.account.schedule.getNextClosingTime();
      var closesToday = closeDate.day == now.day;
      var day =
          closesToday ? '' : ScheduleHelper.getWeekdayName(closeDate.weekday);

      return localizations.translate(
        'CLOSES_AT',
        params: {
          'day': localizations.translate(day) +
              ' ' +
              localizations.translate('AT'),
          'at': DateFormat.Hm(localizations.locale.languageCode)
              .format(closeDate),
        },
      );
    }
    if (state == ScheduleState.openAllDay) {
      return localizations.translate('OPEN_ALL_DAY');
    }

    // Closed
    var openDate = widget.account.schedule.getNextOpeningTime();
    var opensToday = openDate.day == now.day;
    var day = opensToday ? '' : ScheduleHelper.getWeekdayName(openDate.weekday);

    return localizations.translate(
      'OPENS_AT',
      params: {
        'day':
            localizations.translate(day) + ' ' + localizations.translate('AT'),
        'at': DateFormat.Hm(localizations.locale.languageCode).format(openDate),
      },
    );
  }

  void _launchWeb() async {
    BrowserHelper.openBrowser(widget.account.webUrl);
  }

  void _launchMapsUrl() async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${widget.account.latitude},${widget.account.longitude}';
    BrowserHelper.openBrowser(url);
  }

  void _call() async {
    BrowserHelper.openCallPhone(widget.account.fullPhone);
  }
}
