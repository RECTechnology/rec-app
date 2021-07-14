import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';

class RecFilterButton extends StatefulWidget {
  final bool disabled;
  final String label;
  final IconData icon;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Function() onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final double borderRadius;

  const RecFilterButton({
    Key key,
    this.onPressed,
    this.label,
    this.icon,
    this.padding = Paddings.filterButton,
    this.margin = EdgeInsets.zero,
    this.disabled = false,
    this.textColor = Brand.grayDark,
    this.iconColor = Brand.grayDark,
    this.backgroundColor = Colors.white,
    this.borderRadius = 6,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RecActionButton();
  }
}

class _RecActionButton extends State<RecFilterButton> {
  var color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 27,
      margin: widget.margin,
      child: ElevatedButton(
        onPressed: widget.disabled ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(
          primary: widget.backgroundColor,
          padding: widget.padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
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
                    color: widget.iconColor ?? Colors.black,
                  )
                : SizedBox(),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: LocalizedText(
                widget.label,
                style: TextStyle(
                    color: widget.textColor,
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
