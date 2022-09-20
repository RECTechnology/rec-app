import 'package:flutter/material.dart';
import 'package:rec/styles/box_decorations.dart';
import 'package:rec/preferences.dart';

/// A Widget that wraps a Widget with an info tooltip. With branded styles.
class InfoTooltip extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;
  final Color messageColor;
  final String message;

  const InfoTooltip({
    Key? key,
    required this.child,
    required this.message,
    this.backgroundColor = Colors.black87,
    this.messageColor = Colors.white,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _InfoTooltip();
  }
}

class _InfoTooltip extends State<InfoTooltip> {
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();

    return Tooltip(
      key: key,
      message: widget.message,
      showDuration: Preferences.tooltipShowDuration,
      waitDuration: Preferences.tooltipWaitDuration,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecorations.infoTooltip(color: widget.backgroundColor),
      textStyle: TextStyle(
        fontSize: 12,
        color: widget.messageColor,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(key),
        child: widget.child,
      ),
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}
