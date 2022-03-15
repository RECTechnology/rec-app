import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Text/LocalizedText.dart';

class NoPermissionsToPay extends StatelessWidget {
  const NoPermissionsToPay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.cancel, size: 80),
            const SizedBox(height: 16),
            LocalizedText(
              'NO_PERMISSIONS_TO_PAY',
              textAlign: TextAlign.center,
            ),
            RecActionButton(
              label: 'RETURN',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
