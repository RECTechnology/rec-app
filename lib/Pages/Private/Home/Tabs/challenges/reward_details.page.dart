import 'package:flutter/material.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/rounded_network_image.dart';
import 'package:rec/config/theme.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class RewardDetailsPage extends StatefulWidget {
  final TokenReward reward;

  RewardDetailsPage({Key? key, required this.reward}) : super(key: key);

  @override
  State<RewardDetailsPage> createState() => _RewardDetailsPageState();
}

class _RewardDetailsPageState extends State<RewardDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);

    return Scaffold(
      appBar: EmptyAppBar(
        context,
        title: 'REWARD',
      ),
      body: Container(
        decoration: BoxDecoration(gradient: recTheme!.accountTypeGradient(Account.TYPE_PRIVATE)),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LocalizedText(
                  widget.reward.description,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                if (widget.reward.authorUrl != null) const SizedBox(height: 16),
                if (widget.reward.authorUrl != null)
                  LocalizedText(
                    widget.reward.authorUrl!,
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 16),
                RoundedNetworkImage(
                  imageUrl: widget.reward.image,
                  width: null,
                  height: null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
