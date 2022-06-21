import 'package:flutter/material.dart';
import 'package:rec/Components/Icons/svg_icon.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/qualifications/qualification_badge.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class BadgeSection extends StatelessWidget {
  final List<Badge> badges;

  const BadgeSection({
    Key? key,
    required this.badges,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)?.locale ?? AppLocalizations.supportedLocales[0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocalizedText(
          'BADGES_RATED_BY_COMUNITY',
          style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          children: [
            for (final badge in badges)
              Tooltip(
                message: badge.getDescriptionForLocale(locale),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                  child: ActionlessQualificationBadge(
                    icon: (badge.imageUrl != null)
                        ? NetworkSVGIcon(
                            url: badge.imageUrl!,
                          )
                        : Icon(Icons.error),
                    label: Text(badge.getNameForLocale(locale)),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
