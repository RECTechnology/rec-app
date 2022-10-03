import 'package:flutter/material.dart';

class RewardsTab extends StatefulWidget {
  RewardsTab({Key? key}) : super(key: key);

  @override
  State<RewardsTab> createState() => _RewardsTabState();
}

class _RewardsTabState extends State<RewardsTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('rewards'),
        ],
      ),
    );
  }
}
