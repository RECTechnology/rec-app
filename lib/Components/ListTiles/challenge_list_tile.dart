import 'package:flutter/material.dart';
import 'package:rec/Components/GrayBox.dart';
import 'package:rec/Components/Info/countdown_timer.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Text/styled_text.dart';
import 'package:rec/Components/rounded_network_image.dart';
import 'package:rec/config/theme.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ChallengeListTile extends StatefulWidget {
  final EdgeInsets padding;
  final Function? onTap;
  final Widget? trailing;
  final Challenge challenge;

  ChallengeListTile({
    Key? key,
    required this.challenge,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 8,
    ),
    this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  State<ChallengeListTile> createState() => _ChallengeListTileState();
}

class _ChallengeListTileState extends State<ChallengeListTile> {
  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: recTheme!.grayLight3,
            ),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _topPart(),
              _bottomPart(),
            ],
          ),
        );
      },
    );
  }

  _topPart() {
    final recTheme = RecTheme.of(context);

    return Padding(
      padding: widget.padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          RoundedNetworkImage(
            imageUrl: widget.challenge.coverImage,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocalizedText(
                  widget.challenge.title,
                  style: recTheme!.textTheme.pageSubtitle1.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: recTheme.grayDark,
                  ),
                  uppercase: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                _countdownBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _countdownBar() {
    final recTheme = RecTheme.of(context);
    final challenge = widget.challenge;
    final isTxsChallenge = challenge.isThresholdChallenge;
    final isAmountChallenge = challenge.isAmountChallenge;
    final stats = challenge.stats;
    double percentage = 0;

    // Calculate percentage remaining, must be between 0 and 1
    if (isTxsChallenge && stats.totalTxs > 0) {
      percentage = 1 - (challenge.threshold - stats.totalTxs) / challenge.threshold;
    } else if (isAmountChallenge && stats.totalAmount > 0) {
      percentage = 1 - (challenge.amountRequired - stats.totalAmount) / challenge.amountRequired;
    } else if (challenge.amountRemaining <= 0 && challenge.txsRemaining <= 0) {
      percentage = 1;
    }

    // Calculate remaining, must be > 0
    num remaining = 0;

    if (challenge.amountRemaining > 0) {
      remaining = Currency.rec.scaleAmount(challenge.amountRemaining);
    } else if (challenge.txsRemaining > 0) {
      remaining = challenge.txsRemaining;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isTxsChallenge)
              LocalizedStyledText(
                remaining == 1 ? 'REMAINING_TXS_SINGLE' : 'REMAINING_TXS',
                style: recTheme!.textTheme.link.copyWith(fontWeight: FontWeight.w400, fontSize: 12),
                params: {
                  'remaining': remaining,
                },
              ),
            if (isAmountChallenge)
              LocalizedStyledText(
                remaining == 1 ? 'REMAINING_AMOUNT_SINGLE' : 'REMAINING_AMOUNT',
                style: recTheme!.textTheme.link.copyWith(fontWeight: FontWeight.w400, fontSize: 12),
                params: {
                  'remaining': remaining,
                },
              ),
            ChallengeCountdownWidget(
              date: widget.challenge.finishDate,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: recTheme!.backgroundPrivateColor,
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  _bottomPart() {
    final captionTheme = Theme.of(context).textTheme.caption;

    return GrayBox(
      padding: widget.padding,
      height: null,
      width: double.infinity,
      radius: 0,
      child: LocalizedText(
        widget.challenge.description,
        style: captionTheme!.copyWith(fontSize: 12),
      ),
    );
  }
}
