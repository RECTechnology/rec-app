import 'package:flutter/material.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class InfoSplash extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const InfoSplash({
    Key key,
    @required this.title,
    @required this.icon,
    this.subtitle,
    this.iconColor = Brand.primaryColor,
  }) : super(key: key);

  @override
  _InfoSplash createState() => _InfoSplash();
}

class _InfoSplash extends State<InfoSplash> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Icon(
            widget.icon,
            size: 65,
            color: widget.iconColor,
          ),
          const SizedBox(height: 32),
          Text(
            localizations.translate(widget.title),
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
          widget.subtitle != null
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    localizations.translate(widget.subtitle),
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
