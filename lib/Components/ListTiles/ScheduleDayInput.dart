import 'package:flutter/material.dart';
import 'package:rec/Components/GrayBox.dart';
import 'package:rec/Components/Inputs/TimeInput.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Entities/Schedule/ScheduleDay.ent.dart';
import 'package:rec/Helpers/DateHelper.dart';

enum CopyPasteAction {
  copy,
  paste,
}

/// Renders a tile containing the configuration, inputs for a specific [ScheduleDay]
class ScheduleDayInput extends StatelessWidget {
  final int weekday;
  final bool closed;
  final bool opens24Hours;
  final bool isNotAvailable;
  final ScheduleDay day;
  final ValueChanged<ScheduleDay> onChange;
  final ValueChanged<CopyPasteAction> onAction;
  final Function() onCompleteDay;

  ScheduleDayInput({
    Key key,
    @required this.weekday,
    @required this.onChange,
    @required this.day,
    @required this.onAction,
    this.onCompleteDay,
    this.closed = false,
    this.opens24Hours = false,
    this.isNotAvailable = false,
  }) : super(key: key);

  void _fillDay() {
    if (onCompleteDay != null) {
      onCompleteDay();
    }
  }

  @override
  Widget build(BuildContext context) {
    var content = <Widget>[
      Row(
        children: [
          Expanded(
            child: TimeInput(
              value: day.firstOpen,
              helpText: '',
              onChange: (String value) {
                onChange(day..firstOpen = value);
              },
              closed: closed || !day.opens,
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
              closed: closed || !day.opens,
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),
      Row(
        children: [
          Expanded(
            child: TimeInput(
              value: day.secondOpen,
              helpText: '',
              onChange: (String value) {
                onChange(day..secondOpen = value);
              },
              closed: closed || !day.opens,
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
              closed: closed || !day.opens,
            ),
          ),
        ],
      )
    ];

    if (closed) {
      content = [GrayBox(child: Center(child: LocalizedText('closed')))];
    }

    if (opens24Hours) {
      content = [GrayBox(child: Center(child: LocalizedText('full')))];
    }

    if (isNotAvailable) {
      content = [GrayBox(child: Center(child: LocalizedText('not_available')))];
    }

    var center = opens24Hours || closed || isNotAvailable;

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        crossAxisAlignment:
            center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
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
                      : (bool value) {
                          if (!day.opens) {
                            // Was closed now is open, so we try to fill in the data
                            // this is delegated to the parent widget to do
                            _fillDay();
                          }

                          onChange(day..opens = value);
                        },
                ),
                LocalizedText(
                  DateHelper.getWeekdayName(weekday),
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment:
                  center ? CrossAxisAlignment.end : CrossAxisAlignment.center,
              children: content,
            ),
          ),
          Expanded(
            flex: 1,
            child: PopupMenuButton<CopyPasteAction>(
              iconSize: 20,
              onSelected: onAction,
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<CopyPasteAction>(
                  value: CopyPasteAction.copy,
                  child: LocalizedText('COPY'),
                ),
                PopupMenuItem<CopyPasteAction>(
                  value: CopyPasteAction.paste,
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
