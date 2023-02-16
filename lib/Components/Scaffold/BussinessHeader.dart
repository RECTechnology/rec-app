import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rec/Components/Info/rec_circle_avatar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class BussinessHeader extends StatefulWidget with PreferredSizeWidget {
  final Account? account;
  final double size = 120;
  final Widget? avatarBadge;
  final Widget? subtitle;

  BussinessHeader(
    this.account, {
    Key? key,
    this.avatarBadge,
    this.subtitle,
  }) : super(key: key);

  @override
  _BussinessHeaderState createState() => _BussinessHeaderState();

  @override
  Size get preferredSize => Size.fromHeight(size);
}

class _BussinessHeaderState extends State<BussinessHeader> {
  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);

    return PreferredSize(
      preferredSize: widget.preferredSize,
      child: Stack(
        children: [
          Container(
            height: widget.preferredSize.height,
            decoration: BoxDecoration(
              image: Checks.isNotEmpty(widget.account!.publicImage)
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        widget.account!.publicImage!,
                      ),
                    )
                  : null,
            ),
          ),
          Container(
            height: widget.preferredSize.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white.withAlpha(0), Colors.white.withAlpha(255)],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24, 9, 24, 11),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: CircleAvatarRec(
                          imageUrl: widget.account!.companyImage,
                          name: widget.account!.name,
                          radius: 32,
                        ),
                      ),
                      widget.avatarBadge ?? SizedBox.shrink(),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 15, 0, 7),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            widget.account!.name ?? 'Text not found',
                            style: TextStyle(
                              fontSize: 18,
                              color: recTheme!.grayDark,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        widget.subtitle ??
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.schedule_outlined, color: recTheme.grayDark, size: 20),
                                SizedBox(width: 5),
                                LocalizedText(
                                  widget.account!.schedule!.getStateNameForDate(DateTime.now()),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: recTheme.grayDark,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  overflow: TextOverflow.visible,
                                ),
                                if (widget.account!.schedule != null)
                                  NextScheduleState(
                                    schedule: widget.account!.schedule!,
                                  ),
                              ],
                            ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NextScheduleState extends StatefulWidget {
  final Schedule schedule;
  const NextScheduleState({Key? key, required this.schedule}) : super(key: key);
  @override
  State<NextScheduleState> createState() => _NextScheduleStateState();
}

class _NextScheduleStateState extends State<NextScheduleState> {
  get schedule => widget.schedule;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final state = schedule.getStateForDate(now);

    if (schedule.type == ScheduleType.CLOSED || schedule.type == ScheduleType.NOT_AVAILABLE) {
      return SizedBox.shrink();
    } else if (state == ScheduleState.openAllDay) {
      return SizedBox.shrink();
    } else if (state == ScheduleState.open) {
      return closesAt(context);
    }

    return opensAt(context);
  }

  Widget closesAt(BuildContext context) {
    final now = DateTime.now();
    final nextClosingTime = schedule.getNextClosingTime(now);

    if (nextClosingTime == null) return SizedBox.shrink();

    final opensToday = nextClosingTime.day == now.day;
    final opensTomorrow = nextClosingTime.day == now.add(Duration(days: 1));

    String closingTranslationKey = 'closes_at';
    String closing = '';

    if (opensToday) {
      closing = DateFormat.Hm().format(nextClosingTime);
    } else if (opensTomorrow) {
      closing = 'tomorrow';
      closingTranslationKey = 'closes_at_day';
    } else {
      closing = DateHelper.getWeekdayName(nextClosingTime.weekday);
      closingTranslationKey = 'closes_at_day';
    }
    return _createLabel(closingTranslationKey, closing);
  }

  Widget opensAt(BuildContext context) {
    final now = DateTime.now();
    final nextOpeningTime = schedule.getNextOpeningTime(now);

    // If we have no next opening time, just return empty box
    if (nextOpeningTime == null) return SizedBox.shrink();

    final opensToday = nextOpeningTime.day == now.day;
    final opensTomorrow = nextOpeningTime.day == now.add(Duration(days: 1));

    String closingTranslationKey = 'opens_at';
    String opens = '';

    if (opensToday) {
      opens = DateFormat.Hm().format(nextOpeningTime);
    } else if (opensTomorrow) {
      opens = 'tomorrow';
      closingTranslationKey = 'opens_at_day';
    } else {
      opens = DateHelper.getWeekdayName(nextOpeningTime.weekday);
      closingTranslationKey = 'opens_at_day';
    }

    return _createLabel(closingTranslationKey, opens);
  }

  Widget _createLabel(String key, String when) {
    final recTheme = RecTheme.of(context);
    final localizations = AppLocalizations.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text('-'),
        ),
        Container(
          child: LocalizedText(
            key,
            params: {
              'when': localizations!.translate(when).toLowerCase(),
            },
            style: TextStyle(
              fontSize: 14,
              color: recTheme?.grayDark,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
            ),
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}
