import 'package:flutter/material.dart';
import 'package:rec/Lang/AppLocalizations.dart';

class InfoColumn extends StatefulWidget {
  final String label;
  final String value;

  const InfoColumn({Key key, this.label, this.value}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _InfoColumn();
  }
}

class _InfoColumn extends State<InfoColumn> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(localizations.translate(widget.label)),
          SizedBox(height: 8),
          Text(
            localizations.translate(widget.value),
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
