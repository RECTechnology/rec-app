import 'package:flutter/material.dart';
import 'package:rec/Components/boxes.dart';
import 'package:rec/Components/Inputs/TimeInput.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

enum ScheduleDayAction {
  copy,
  paste,

  /// Intensive schedule (1 timeframes per day)
  intensive,

  /// Split schedule (2 timeframes per day)
  split,
}

/// Renders a tile containing the configuration, inputs for a specific [ScheduleDay]
class ScheduleDayInput extends StatelessWidget {
  final int? weekday;
  final bool closed;
  final bool opens24Hours;
  final bool isNotAvailable;
  final Schedule schedule;
  final ScheduleDay day;
  final ValueChanged<ScheduleDay> onChange;
  final ValueChanged<ScheduleDayAction> onAction;
  final Function()? onCompleteDay;

  ScheduleDayInput({
    Key? key,
    required this.weekday,
    required this.onChange,
    required this.day,
    required this.schedule,
    required this.onAction,
    this.onCompleteDay,
    this.closed = false,
    this.opens24Hours = false,
    this.isNotAvailable = false,
  }) : super(key: key);

  void _fillDay() {
    if (onCompleteDay != null) {
      onCompleteDay!();
    }
  }

  List<Widget> _getContent() {
    if (closed) return [GrayBox(child: Center(child: LocalizedText('closed')))];
    if (opens24Hours) return [GrayBox(child: Center(child: LocalizedText('full')))];
    if (isNotAvailable) return [GrayBox(child: Center(child: LocalizedText('not_available')))];

    return [
      Row(
        children: [
          Expanded(
            child: TimeInput(
              value: day.firstOpen,
              helpText: '',
              onChange: (String value) {
                onChange(day..firstOpen = value);
              },
              closed: closed || !day.opens!,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.remove),
          ),
          Expanded(
            child: TimeInput(
              value: day.firstClose,
              helpText: '',
              onChange: (String value) {
                onChange(day..firstClose = value);
              },
              closed: closed || !day.opens!,
            ),
          ),
        ],
      ),
      if (!day.intensive) const SizedBox(height: 4),
      if (!day.intensive)
        Row(
          children: [
            Expanded(
              child: TimeInput(
                value: day.secondOpen,
                helpText: '',
                onChange: (String value) {
                  onChange(day..secondOpen = value);
                },
                closed: closed || !day.opens!,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.remove),
            ),
            Expanded(
              child: TimeInput(
                value: day.secondClose,
                helpText: '',
                onChange: (String value) {
                  onChange(day..secondClose = value);
                },
                closed: closed || !day.opens!,
              ),
            ),
          ],
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final content = _getContent();
    final center = opens24Hours || closed || isNotAvailable;

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Checkbox(
                  value: (closed || isNotAvailable) ? false : day.opens,
                  onChanged: closed
                      ? null
                      : (bool? value) {
                          if (!day.opens!) {
                            // Was closed now is open, so we try to fill in the data
                            // this is delegated to the parent widget to do
                            _fillDay();
                          }

                          onChange(day..opens = value);
                        },
                ),
                LocalizedText(
                  DateHelper.getWeekdayName(weekday!),
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: center ? CrossAxisAlignment.end : CrossAxisAlignment.center,
              children: content,
            ),
          ),
          Expanded(
            flex: 1,
            child: PopupMenuButton<ScheduleDayAction>(
              iconSize: 20,
              onSelected: onAction,
              itemBuilder: (BuildContext context) => [
                if (!day.intensive && schedule.type == ScheduleType.TIMETABLE)
                  PopupMenuItem<ScheduleDayAction>(
                    value: ScheduleDayAction.intensive,
                    child: LocalizedText('INTENSIVE_SCHEDULE'),
                  ),
                if (day.intensive && schedule.type == ScheduleType.TIMETABLE)
                  PopupMenuItem<ScheduleDayAction>(
                    value: ScheduleDayAction.split,
                    child: LocalizedText('SPLIT_SCHEDULE'),
                  ),
                PopupMenuItem<ScheduleDayAction>(
                  value: ScheduleDayAction.copy,
                  child: LocalizedText('COPY'),
                ),
                PopupMenuItem<ScheduleDayAction>(
                  value: ScheduleDayAction.paste,
                  child: LocalizedText('PASTE'),
                ),
              ],
              child: Icon(Icons.more_vert),
            ),
          )
        ],
      ),
    );
  }
}
