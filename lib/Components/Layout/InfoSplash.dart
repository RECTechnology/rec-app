import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';

class InfoSplash extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final EdgeInsets padding;

  const InfoSplash({
    Key? key,
    required this.title,
    required this.icon,
    this.subtitle,
    this.iconColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0),
  }) : super(key: key);

  @override
  _InfoSplash createState() => _InfoSplash();
}

class _InfoSplash extends State<InfoSplash> {
  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    
    return Padding(
      padding: widget.padding,
      child: Column(
        children: [
          Icon(
            widget.icon,
            size: 65,
            color: widget.iconColor ?? recTheme!.primaryColor,
          ),
          const SizedBox(height: 32),
          LocalizedText(
            widget.title,
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
          widget.subtitle != null
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: LocalizedText(
                    widget.subtitle!,
                    style: Theme.of(context).textTheme.caption,
                    textAlign: TextAlign.center,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
