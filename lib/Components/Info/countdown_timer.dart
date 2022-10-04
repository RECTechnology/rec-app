import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/providers/AppLocalizations.dart';

import 'timer_refresh_widget.dart';

typedef CountdownBuilder = Widget Function(BuildContext context, String value);

class CountdownWidget extends TimerRefreshWidget {
  const CountdownWidget({
    Key? key,
    required this.builder,
    required this.date,
    this.locale,
    this.allowFromNow = false,
    this.clock,
    Duration refreshRate = const Duration(minutes: 1),
  }) : super(key: key, refreshRate: refreshRate);

  final CountdownBuilder builder;
  final DateTime date;
  final DateTime? clock;
  final String? locale;
  final bool allowFromNow;

  @override
  Widget build(BuildContext context) {
    return builder(context, _timeRemaining(context));
  }

  _timeRemaining(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final remainingTime = date.difference(clock ?? DateTime.now());
    final remainingDays = remainingTime.inDays;
    final remainingHours = remainingTime.inHours;

    final minutesRest = remainingHours * 60;
    final remainingMinutes = remainingTime.inMinutes - minutesRest;

    String label;
    if (remainingHours < 24) {
      label = '${remainingHours}h ${remainingMinutes}m';
    } else if (remainingDays == 1) {
      label = localizations!.translate('DAY_REMAINING');
      // label = '$remainingDays dia';
    } else {
      label = localizations!.translate('DAYS_REMAINING', params: {'remainingDays': remainingDays});
      // label = '$remainingDays dias';
    }

    return label;
  }
}

class ChallengeCountdownWidget extends StatelessWidget {
  final DateTime date;
  final DateTime? clock;

  const ChallengeCountdownWidget({Key? key, required this.date, this.clock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final captionTheme = Theme.of(context).textTheme.caption;

    return CountdownWidget(
      builder: (BuildContext context, String value) {
        return Row(
          children: [
            LocalizedText(
              value,
              style: captionTheme!.copyWith(fontSize: 10),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.hourglass_top,
              size: 12,
              color: captionTheme.color,
            ),
          ],
        );
      },
      date: date,
      clock: clock,
    );
  }
}
