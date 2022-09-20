import 'package:flutter/material.dart';
import 'package:rec/Components/Icons/svg_icon.dart';
import 'package:rec/config/theme.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

/// Holds all states for a Qualification
enum QualificationState { yes, no, unset }

extension QualificationStateValue on QualificationState {
  bool? get value {
    switch (this) {
      case QualificationState.yes:
        return true;
      case QualificationState.no:
        return false;
      case QualificationState.unset:
      default:
        return null;
    }
  }
}

class QualificationVote {
  final Qualification qualification;
  QualificationState state;

  QualificationVote({
    required this.qualification,
    this.state = QualificationState.unset,
  });
}

/// Maps [QualificationState]s to the next [QualificationState] in the cycle
const Map<QualificationState, QualificationState> stateCycleMap = {
  QualificationState.unset: QualificationState.yes,
  QualificationState.yes: QualificationState.no,
  QualificationState.no: QualificationState.unset,
};

/// Displays a badge for a Qualification, and adds the logic to cycle though the [QualificationState]s
///
/// If you don't need the actions, you can use [ActionlessQualificationBadge]
class QualificationBadge extends StatefulWidget {
  final String label;
  final String? svgIconUrl;
  final QualificationState initialValue;
  final ValueChanged<QualificationState>? onChange;
  final double? height;
  final double? width;

  const QualificationBadge({
    Key? key,
    required this.label,
    required this.svgIconUrl,
    this.initialValue = QualificationState.unset,
    this.onChange,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  State<QualificationBadge> createState() => _QualificationBadgeState();
}

class _QualificationBadgeState extends State<QualificationBadge> {
  QualificationState currentState = QualificationState.unset;

  @override
  void initState() {
    currentState = widget.initialValue;
    super.initState();
  }

  void cycleState() {
    setState(() {
      currentState = stateCycleMap[currentState] ?? QualificationState.unset;
      if (widget.onChange != null) widget.onChange!(currentState);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: cycleState,
      child: ActionlessQualificationBadge(
        label: Text(widget.label),
        icon: (widget.svgIconUrl != null)
            ? NetworkSVGIcon(
                url: widget.svgIconUrl!,
              )
            : Icon(Icons.error),
        state: currentState,
        width: widget.width,
        height: widget.height,
      ),
    );
  }
}

/// Displays a badge for the provided [QualificationState]
class ActionlessQualificationBadge extends StatefulWidget {
  final Widget label;
  final Widget icon;
  final QualificationState state;
  final double? height;
  final double? width;

  const ActionlessQualificationBadge({
    Key? key,
    required this.label,
    required this.icon,
    this.state = QualificationState.unset,
    this.height = 32,
    this.width,
  }) : super(key: key);

  @override
  State<ActionlessQualificationBadge> createState() => _ActionlessQualificationBadgeState();
}

class _ActionlessQualificationBadgeState extends State<ActionlessQualificationBadge> {
  _unsetDecoration(RecThemeData theme) => BoxDecoration(
        border: Border.all(color: theme.grayLight2),
        borderRadius: BorderRadius.circular(6),
      );
  _yesDecoration(RecThemeData theme) => BoxDecoration(
        border: Border.all(color: theme.green),
        color: theme.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
      );
  _noDecoration(RecThemeData theme) => BoxDecoration(
        border: Border.all(color: theme.red),
        color: theme.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
      );

  BoxDecoration _getDecorationForState(RecThemeData theme) {
    switch (widget.state) {
      case QualificationState.yes:
        return _yesDecoration(theme);
      case QualificationState.no:
        return _noDecoration(theme);
      default:
        return _unsetDecoration(theme);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);

    return Container(
      decoration: _getDecorationForState(recTheme!),
      width: widget.width,
      height: widget.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.icon,
            const SizedBox(width: 6),
            widget.label,
          ],
        ),
      ),
    );
  }
}
