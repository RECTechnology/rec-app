import 'package:flutter/material.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/qualifications/qualification_badge.dart';
import 'package:rec/providers/AppLocalizations.dart';

class QualificationBadgeList extends StatelessWidget {
  final List<QualificationVote> qualifications;
  final ValueChanged<QualificationVote>? qualificationChanged;

  const QualificationBadgeList({
    Key? key,
    this.qualificationChanged,
    this.qualifications = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)?.locale ??
        AppLocalizations.supportedLocales[0];

    return Wrap(
      children: [
        for (final qualificationVote in qualifications)
          Padding(
            padding: const EdgeInsets.only(right: 18.0, bottom: 16.0),
            child: QualificationBadge(
              label: qualificationVote.qualification.badge
                  .getNameForLocale(locale),
              svgIconUrl: qualificationVote.qualification.badge.imageUrl,
              initialValue: qualificationVote.state,
              onChange: (state) {
                if (qualificationChanged != null) {
                  qualificationChanged!(
                    qualificationVote..state = state,
                  );
                }
              },
            ),
          ),
      ],
    );
  }
}
