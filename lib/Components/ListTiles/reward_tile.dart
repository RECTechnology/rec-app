import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rec/Components/GrayBox.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class RewardTile extends StatelessWidget {
  final TokenReward reward;
  final VoidCallback? onTap;

  const RewardTile({Key? key, required this.reward, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GrayBox(
      height: null,
      width: 128,
      radius: 6,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CachedNetworkImage(
            imageUrl: reward.image,
            width: 128,
            height: 128,
            errorWidget: (c, e, s) {
              return GrayBox(
                child: Center(
                  child: LocalizedText('ERROR'),
                ),
              );
            },
          ),
          _bottomPart(context),
        ],
      ),
    );
  }

  _bottomPart(BuildContext context) {
    final captionTheme = Theme.of(context).textTheme.caption;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LocalizedText(
        reward.name,
        style: captionTheme!.copyWith(
          fontSize: 12,
          color: RecTheme.of(context)?.grayDark,
        ),
      ),
    );
  }
}
