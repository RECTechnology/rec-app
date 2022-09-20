import 'package:flutter/material.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/LimitAndVerification/UploadDocument/UploadDocument.dart';
import 'package:rec/config/theme.dart';

class PickImage extends StatefulWidget {
  final Function(String url)? onPick;
  final Color? color;

  final String? title;
  final String? buttonLabel;
  final String? hint;

  final Widget? child;
  final EdgeInsets padding;

  PickImage({
    Key? key,
    this.onPick,
    this.color,
    this.title,
    this.buttonLabel,
    this.hint,
    this.child,
    this.padding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  _PickImageState createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  void _onTap() async {
    var link = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return UploadDocument(
            title: widget.title ?? 'IMAGE',
            buttonLabel: widget.buttonLabel ?? 'UPDATE',
            hint: widget.hint ?? 'IMAGE',
          );
        },
      ),
    );

    if (link != null && widget.onPick != null) {
      widget.onPick!(link);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);

    return Padding(
      padding: widget.padding,
      child: InkResponse(
        onTap: _onTap,
        child: widget.child ??
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color ?? recTheme!.primaryColor,
              ),
              child: Icon(Icons.add_a_photo, color: Colors.white, size: 16),
            ),
      ),
    );
  }
}
