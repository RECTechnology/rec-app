import 'package:flutter/material.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';

class RecFilterButton extends StatefulWidget {
  final bool disabled;
  final String label;
  final IconData icon;
  final EdgeInsets padding;
  final Function() onPressed;
  final Color backgroundColor;
  final Color textColor;

  const RecFilterButton(
      {Key key,
      this.onPressed,
      this.label,
      this.icon,
      this.padding = Paddings.button,
      this.disabled = false,
      this.textColor,
      this.backgroundColor})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RecActionButton();
  }
}

class _RecActionButton extends State<RecFilterButton> {
  var color = Colors.white;
  var textColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Padding(
        padding: widget.padding,
        child: Container(
          height: 27,
          child: ElevatedButton(
            onPressed: widget.disabled ? null : widget.onPressed,
            style: ElevatedButton.styleFrom(
              primary: widget.backgroundColor,
            ),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Only show icon if icon is passed
                  widget.icon != null
                      ? Icon(
                          widget.icon,
                          size: 16,
                          color: Colors.black,
                        )
                      : SizedBox(),
                  Text(
                    localizations.translate(widget.label),
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
