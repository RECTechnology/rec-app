import 'package:flutter/material.dart';
import 'package:rec/Components/Info/countdown_timer.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
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
          _image(),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
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

  _image() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      child: Container(
        width: 72,
        height: 72,
        child: Center(
          child: Image.network(
            widget.challenge.coverImage,
            errorBuilder: (c, e, s) {
              return Container(
                child: Center(
                  child: LocalizedText('ERROR'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _countdownBar() {
    final recTheme = RecTheme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LocalizedText(
              'REMAINING_RECS',
              style: recTheme!.textTheme.link.copyWith(fontWeight: FontWeight.w400, fontSize: 12),
            ),
            _timeRemaining(),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          child: LinearProgressIndicator(
            value: 0.5,
            backgroundColor: recTheme.backgroundPrivateColor,
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  _bottomPart() {
    final recTheme = RecTheme.of(context);
    final captionTheme = Theme.of(context).textTheme.caption;

    return Container(
      padding: widget.padding,
      color: recTheme!.defaultAvatarBackground,
      child: LocalizedText(
        widget.challenge.description,
        style: captionTheme!.copyWith(fontSize: 10),
      ),
    );
  }

  _timeRemaining() {
    return ChallengeCountdownWidget(
      date: widget.challenge.endDate,
    );
  }
}
