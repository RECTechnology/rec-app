import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/styles/paddings.dart';

class RecActionButton extends StatefulWidget {
  final bool disabled;
  final String? label;
  final IconData? icon;
  final IconData? leading;
  final EdgeInsets padding;
  final Function()? onPressed;
  final Color? backgroundColor;

  const RecActionButton({
    Key? key,
    this.onPressed,
    this.label,
    this.icon,
    this.leading,
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
    return Padding(
      padding: widget.padding,
      child: ElevatedButton(
        onPressed: widget.disabled ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor,
          foregroundColor: Colors.white,
        ),
        child: Container(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.leading != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 2),
                      child: Icon(
                        widget.leading,
                        size: 18,
                      ),
                    )
                  : SizedBox(),
              LocalizedText(widget.label ?? ''),
              widget.icon != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 16.0, top: 2),
                      child: Icon(
                        widget.icon,
                        size: 18,
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
