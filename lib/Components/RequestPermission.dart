import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/OutlinedListTile.dart';
import 'package:rec/Permissions/PermissionProvider.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';

class RequestPermission extends StatefulWidget {
  final PermissionProvider permission;
  final Function() onAccept;
  final Function() onDecline;

  const RequestPermission({
    Key key,
    @required this.permission,
    @required this.onAccept,
    @required this.onDecline,
  })  : assert(permission != null),
        super(key: key);

  @override
  _RequestPermission createState() => _RequestPermission();
}

class _RequestPermission extends State<RequestPermission> {
  bool notAccepted = false;

  @override
  void initState() {
    widget.permission.isGranted().then((isGranted) {
      if (isGranted) {
        return widget.onAccept();
      }

      notAccepted = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: Padding(
        padding: Paddings.page,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(),
            Column(children: [
              Icon(
                widget.permission.icon,
                size: 65,
                color: Brand.primaryColor,
              ),
              const SizedBox(height: 32),
              Text(
                localizations.translate(widget.permission.title),
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  localizations.translate(widget.permission.subtitle),
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.center,
                ),
              ),
            ]),
            Column(
              children: [
                OutlinedListTile(
                  onPressed: _onDecline,
                  children: [
                    SizedBox(),
                    Text(
                      localizations.translate('DECLINE_PERMISSION'),
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Brand.grayDark),
                    ),
                    SizedBox(),
                  ],
                ),
                RecActionButton(
                  label: 'ACCEPT_PERMISSION',
                  onPressed: _onAccept,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onAccept() {
    widget.permission.request().then((isGranted) {
      print('permission grant granted: $isGranted');
      if (isGranted) {
        return widget.onAccept();
      }

      widget.onDecline();
    });
  }

  void _onDecline() {
    print('permission grant declined');
    widget.onDecline();
  }
}
