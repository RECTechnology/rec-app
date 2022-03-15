import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/text_fields/RecTextField.dart';

/// Shows an input to select a [DateTime]
class YearInputPicker extends StatefulWidget {
  final String? helpText;
  final String? label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  final DateTime? intialTime;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool required;

  final String Function(String?)? validator;

  /// Function to override default [showTimePicker], mostly for testing purposes
  final Future<DateTime> Function(BuildContext context)? getTime;

  YearInputPicker({
    Key? key,
    required this.value,
    required this.onChanged,
    this.label,
    this.helpText,
    this.getTime,
    this.intialTime,
    this.validator,
    DateTime? firstDate,
    DateTime? lastDate,
    this.required = false,
  })  : firstDate = firstDate ?? DateTime.now().subtract(Duration(days: 365 * 100)),
        lastDate = lastDate ?? DateTime.now(),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _DatsInputState();
}

class _DatsInputState extends State<YearInputPicker> {
  TextEditingController controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.value != null) {
      controller.text = widget.value!.year.toString();
    } else {
      controller.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        showBottomSheet(
          context: context,
          builder: (BuildContext context) => Container(
            width: MediaQuery.of(context).size.width,
            child: YearPicker(
              selectedDate: widget.value ?? DateTime.now(),
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              onChanged: (val) {
                Navigator.pop(context);
                controller.text = val.year.toString();
                widget.onChanged(val);
              },
            ),
          ),
        );
      },
      child: IgnorePointer(
        child: RecTextField(
          controller: controller,
          label: widget.label ?? 'YEAR',
          icon: Icon(Icons.hourglass_top),
          validator: widget.validator,
          required: widget.required,
        ),
      ),
    );
  }
}
