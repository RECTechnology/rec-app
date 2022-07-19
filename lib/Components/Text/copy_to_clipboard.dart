import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rec/helpers/RecToast.dart';

class CopyToClipboard extends StatelessWidget {
  final String textToCopy;

  const CopyToClipboard({Key? key, required this.textToCopy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: textToCopy));
        RecToast.showInfo(context, 'COPY_CLIPBOARD');
      },
      icon: Icon(
        Icons.copy,
        size: 16,
      ),
      splashRadius: 18,
    );
  }
}
