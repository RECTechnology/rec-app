import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rec/Components/GrayBox.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Helpers/Checks.dart';

/// Shows an input to select a [TimeOfDay]
class TimeInput extends StatelessWidget {
  final format = DateFormat('H:mm');

  final String helpText;
  final String value;
  final ValueChanged<String> onChange;
  final bool closed;
  final TimeOfDay intialTime;

  /// Function to override default [showTimePicker], mostly for testing purposes
  final Future<TimeOfDay> Function(BuildContext context) getTime;

  TimeInput({
    Key key,
    @required this.value,
    @required this.onChange,
    this.helpText,
    this.closed = false,
    this.getTime,
    this.intialTime,
  }) : super(key: key);

  Future<TimeOfDay> _openDatePicker(BuildContext context) {
    if (getTime != null) return getTime(context);

    return showTimePicker(
      initialTime: _getTimeOfDay(),
      context: context,
      helpText: helpText,
    );
  }

  TimeOfDay _getTimeOfDay() {
    var timeOfDay = TimeOfDay.now();
    if (Checks.isNotEmpty(value)) {
      timeOfDay = TimeOfDay.fromDateTime(format.parse(value));
    }

    return intialTime ?? timeOfDay;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var result = await _openDatePicker(context);

        if (result != null) {
          onChange(result.format(context));
        }
      },
      child: Opacity(
        opacity: (closed || value == null) ? 0.6 : 1,
        child: GrayBox(
          height: 32,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: LocalizedText(
              (closed || value == null) ? 'CLOSED' : value,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
