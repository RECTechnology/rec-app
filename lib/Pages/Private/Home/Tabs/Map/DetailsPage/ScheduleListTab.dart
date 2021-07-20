import 'package:flutter/material.dart';
import 'package:rec/Entities/Schedule/Schedule.ent.dart';
import 'package:rec/Helpers/DateHelper.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class ScheduleListTab extends StatefulWidget {
  final Schedule schedule;

  ScheduleListTab({
    Key key,
    @required this.schedule,
  }) : super(key: key);

  @override
  _ScheduleListTabState createState() => _ScheduleListTabState();
}

class _ScheduleListTabState extends State<ScheduleListTab> {
  @override
  Widget build(BuildContext context) {
    var daysList = List.generate(7, (index) => index + 1);
    var localizations = AppLocalizations.of(context);
    var now = DateTime.now();
    var currentWeekday = now.weekday - 1;

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
                  color: Brand.primaryColor,
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
                var scheduleDay = widget.schedule.days.isNotEmpty
                    ? widget.schedule.getScheduleForDay(weekday - 1)
                    : null;

                var dayScheduleLabel;

                if (widget.schedule.isClosed) {
                  dayScheduleLabel = localizations.translate('CLOSED');
                }

                if (widget.schedule.isOpen24h) {
                  dayScheduleLabel = localizations.translate('OPEN');
                }

                if (widget.schedule.isNotAvailable) {
                  dayScheduleLabel = localizations.translate('N/A');
                }

                var daySchedule = scheduleDay == null ||
                        !scheduleDay.isDefined() ||
                        !scheduleDay.opens
                    ? <Widget>[
                        Text(
                          dayScheduleLabel ?? localizations.translate('CLOSED'),
                          style: weekday % 2 == 0
                              ? Theme.of(context)
                                  .textTheme
                                  .subtitle1
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
                                  .subtitle1
                                  .copyWith(fontWeight: FontWeight.w500)
                              : Theme.of(context).textTheme.subtitle1,
                        ),
                        ...(scheduleDay.isSecondDefined() &&
                                dayScheduleLabel == null
                            ? [
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  '${scheduleDay.secondOpen} - ${scheduleDay.secondClose}',
                                  style: weekday % 2 == 0
                                      ? Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(fontWeight: FontWeight.w500)
                                      : Theme.of(context).textTheme.subtitle1,
                                ),
                              ]
                            : [])
                      ];

                return ListTile(
                  title: Text(
                    localizations.translate(
                      DateHelper.getWeekdayName(weekday),
                    ),
                    style: weekday % 2 == 0
                        ? Theme.of(context)
                            .textTheme
                            .subtitle1
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
