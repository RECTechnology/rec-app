import 'package:flutter/material.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ScheduleTab extends StatefulWidget {
  final Schedule? schedule;
  final ScrollController? scrollController;

  ScheduleTab({
    Key? key,
    required this.schedule,
    this.scrollController,
  }) : super(key: key);

  @override
  _ScheduleTabState createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    final localizations = AppLocalizations.of(context);
    final now = DateTime.now();
    final currentWeekday = now.weekday - 1;

    var daysList = List.generate(7, (index) => index + 1);

    daysList = [
      ...daysList.getRange(currentWeekday, daysList.length),
      ...daysList.getRange(0, currentWeekday),
    ];

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(right: 53),
            child: Container(
              height: 64,
              child: Center(
                child: Icon(
                  Icons.schedule_outlined,
                  color: recTheme!.primaryColor,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: daysList.map((weekday) {
                var scheduleDay = widget.schedule!.days.isNotEmpty
                    ? widget.schedule!.getScheduleForDay(weekday - 1)
                    : null;

                String? dayScheduleLabel;

                if (widget.schedule!.isClosed) {
                  dayScheduleLabel = 'CLOSED';
                }

                if (widget.schedule!.isOpen24h) {
                  dayScheduleLabel = 'OPEN';
                }

                if (widget.schedule!.isNotAvailable) {
                  dayScheduleLabel = 'N/A';
                }

                var daySchedule =
                    scheduleDay == null || !scheduleDay.isDefined() || !scheduleDay.opens!
                        ? <Widget>[
                            Text(
                              localizations!.translate(dayScheduleLabel ?? 'CLOSED'),
                              style: weekday % 2 == 0
                                  ? Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(fontWeight: FontWeight.w500)
                                  : Theme.of(context).textTheme.subtitle1,
                            )
                          ]
                        : <Widget>[
                            Text(
                              dayScheduleLabel ??
                                  '${scheduleDay.firstOpen} - ${scheduleDay.firstClose}',
                              style: weekday % 2 == 0
                                  ? Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(fontWeight: FontWeight.w500)
                                  : Theme.of(context).textTheme.subtitle1,
                            ),
                            ...(scheduleDay.isSecondDefined() && dayScheduleLabel == null
                                ? [
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      '${scheduleDay.secondOpen} - ${scheduleDay.secondClose}',
                                      style: weekday % 2 == 0
                                          ? Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(fontWeight: FontWeight.w500)
                                          : Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ]
                                : [])
                          ];

                return ListTile(
                  title: Text(
                    localizations!.translate(
                      DateHelper.getWeekdayName(weekday),
                    ),
                    style: weekday % 2 == 0
                        ? Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.w500)
                        : Theme.of(context).textTheme.subtitle1,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: daySchedule,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
