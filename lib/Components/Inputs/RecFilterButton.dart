import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/styles/paddings.dart';

class RecFilterButton extends StatefulWidget {
  final bool disabled;
  final String label;
  final IconData? icon;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Function()? onPressed;
  final Color backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final double borderRadius;
  final double elevation;

  const RecFilterButton({
    Key? key,
    this.onPressed,
    required this.label,
    this.icon,
    this.padding = Paddings.filterButton,
    this.margin = EdgeInsets.zero,
    this.disabled = false,
    this.textColor,
    this.iconColor,
    this.backgroundColor = Colors.white,
    this.borderRadius = 6,
    this.elevation = 1,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RecActionButton();
  }
}

class _RecActionButton extends State<RecFilterButton> {
  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);

    return Container(
      height: 27,
      margin: widget.margin,
      child: ElevatedButton(
        onPressed: widget.disabled ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor,
          padding: widget.padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          elevation: widget.elevation,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Only show icon if icon is passed
            widget.icon != null
                ? Icon(
                    widget.icon,
                    size: 16,
                    color: widget.iconColor ?? recTheme!.grayDark,
                  )
                : SizedBox(),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: LocalizedText(
                widget.label,
                style: TextStyle(
                    color: widget.textColor ?? recTheme!.grayDark,
                    fontWeight: FontWeight.w500,
                    fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
