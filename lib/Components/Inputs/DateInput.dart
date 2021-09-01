import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rec/Components/Inputs/text_fields/RecTextField.dart';
import 'package:rec/Helpers/Checks.dart';
import 'package:rec/Providers/All.dart';

/// Shows an input to select a [DateTime]
class DateInput extends StatefulWidget {
  final String helpText;
  final String value;
  final String label;
  final ValueChanged<String> onChange;
  final DateTime intialTime;

  /// Function to override default [showTimePicker], mostly for testing purposes
  final Future<DateTime> Function(BuildContext context) getTime;

  DateInput({
    Key key,
    @required this.value,
    @required this.onChange,
    this.label,
    this.helpText,
    this.getTime,
    this.intialTime,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DatsInputState();
}

class _DatsInputState extends State<DateInput> {
  TextEditingController controller;
  DateFormat format;
  AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    localizations ??= AppLocalizations.of(context);
    format ??= DateFormat('d/M/y');

    controller ??= TextEditingController(
      text: widget.value != null ? format.format(DateTime.parse(widget.value)) : null,
    );
  }

  Future<DateTime> _openDatePicker(BuildContext context) {
    if (widget.getTime != null) return widget.getTime(context);

    return showDatePicker(
      initialDate: _getTimeOfDay(),
      context: context,
      helpText: widget.helpText,
      firstDate: DateTime.now(),
      lastDate: DateTime(3000, 1, 1),
    );
  }

  DateTime _getTimeOfDay() {
    var date = DateTime.now();
    if (Checks.isNotEmpty(widget.value)) {
      date = DateTime.parse(widget.value);
    }

    return widget.intialTime ?? date;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var result = await _openDatePicker(context);

        if (result != null) {
          controller.text = format.format(result);
          widget.onChange(result.toIso8601String());
        }
      },
      child: IgnorePointer(
        child: controller == null
            ? Container()
            : RecTextField(
                controller: controller,
                label: widget.label ?? 'DATE',
                icon: Icon(Icons.hourglass_top),
              ),
      ),
    );
  }
}
