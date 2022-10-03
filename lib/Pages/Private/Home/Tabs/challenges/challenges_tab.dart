import 'package:flutter/material.dart';

class ChallengesTab extends StatefulWidget {
  ChallengesTab({Key? key}) : super(key: key);

  @override
  State<ChallengesTab> createState() => _ChallengesTabState();
}

class _ChallengesTabState extends State<ChallengesTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('Challenges'),
        ],
      ),
    );
  }
}
