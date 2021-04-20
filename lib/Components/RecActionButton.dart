import 'package:flutter/material.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';

class RecActionButton extends StatefulWidget {
  final bool disabled;
  final String label;
  final IconData icon;
  final EdgeInsets padding;
  final Function() onPressed;
  final Color backgroundColor;

  const RecActionButton({
    Key key,
    this.onPressed,
    this.label,
    this.icon,
    this.padding = Paddings.button,
    this.disabled = false,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RecActionButton();
  }
}

class _RecActionButton extends State<RecActionButton> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var color = widget.backgroundColor;

    return Padding(
      padding: widget.padding,
      child: ElevatedButton(
        onPressed: widget.disabled ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(
          primary: widget.backgroundColor ?? color,
          onPrimary: Colors.white,
        ),
        child: Container(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                localizations.translate(widget.label),
                style: TextStyle(fontSize: 20),
              ),
              // Only show icon if icon is passed
              widget.icon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 2),
                      child: Icon(
                        widget.icon,
                        size: 20,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
