import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';

class InfoColumn extends StatefulWidget {
  final String label;
  final String value;

  const InfoColumn({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _InfoColumn();
  }
}

class _InfoColumn extends State<InfoColumn> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocalizedText(widget.label),
          SizedBox(height: 8),
          LocalizedText(
            widget.value,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
