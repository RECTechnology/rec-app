import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rec/Components/Layout/InfoSplash.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/ListTiles/OutlinedListTile.dart';
import 'package:rec/Permissions/permission_data.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';

/// Widget that manages permission requesting
/// * if the permission is [allowed] it ca
/// lls [onAccept]
/// * if it's [denied] it will show a screen explaining why it's used and actions to either accept it or decline it (if `canBeDeclined == true`)
/// * if it's [permanentlyDenied] it says it, and allows user to go to OS app settings
class RequestPermission extends StatefulWidget {
  /// PermissionProvider instance, this tells [RequestPermission] which permission
  /// it's requesting.
  final PermissionData permission;

  /// Callback for when a permission has been accepted
  final Function() onAccept;

  /// Callback for when a permission has been declined
  final Function() onDecline;

  /// Specifies if this request can be declined
  ///   ie: in case the permission is required for the feature to work
  final bool canBeDeclined;

  const RequestPermission({
    Key key,
    @required this.permission,
    @required this.onAccept,
    @required this.onDecline,
    this.canBeDeclined = true,
  })  : assert(permission != null),
        assert(onAccept != null),
        assert(onDecline != null),
        super(key: key);

  @override
  _RequestPermission createState() => _RequestPermission();
}

class _RequestPermission extends State<RequestPermission> {
  bool permanentlyDenied = false;
  bool loaded = false;

  @override
  void initState() {
    widget.permission.permission.status.then(_checkPermission);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: Padding(
        padding: Paddings.page,
        child: loaded
            ? permanentlyDenied
                ? _permanentlyDeniedInfo()
                : _askForPermission()
            : SizedBox(),
      ),
    );
  }

  Widget _askForPermission() {
    var localizations = AppLocalizations.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(),
        InfoSplash(
          icon: widget.permission.icon,
          title: widget.permission.title,
          subtitle: widget.permission.subtitle,
          padding: EdgeInsets.zero,
        ),
        Column(
          children: [
            if (widget.canBeDeclined)
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
    );
  }

  Widget _permanentlyDeniedInfo() {
    var localizations = AppLocalizations.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(),
        InfoSplash(
          icon: Icons.cancel,
          iconColor: Colors.red,
          title: 'PERMISSION_PERMANENTLY_DENIED',
          subtitle: widget.permission.permanentlyDeniedMessage,
          padding: EdgeInsets.zero,
        ),
        Column(
          children: [
            if (widget.canBeDeclined)
              OutlinedListTile(
                onPressed: _onDecline,
                children: [
                  SizedBox(),
                  Text(
                    localizations.translate('RETURN'),
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Brand.grayDark),
                  ),
                  SizedBox(),
                ],
              ),
            RecActionButton(
              label: 'GO_TO_SETTINGS',
              onPressed: _goToAppSettings,
            ),
          ],
        )
      ],
    );
  }

  void _checkPermission(PermissionStatus status) {
    setState(() => loaded = true);
    if (status.isGranted) return widget.onAccept();
    if (status.isDenied) return widget.onDecline();
    if (status.isPermanentlyDenied) {
      setState(() => permanentlyDenied = true);
    }
  }

  /// Opens OS app settings
  void _goToAppSettings() async {
    await openAppSettings();

    // This is here to check permission after user interacts with settings
    // For example, in case permission is denied and he accepts it inside settings
    // It's kind of a bug, fix found [here](https://github.com/Baseflow/flutter-permission-handler/issues/429)
    await widget.permission.request().then(_checkPermission);
  }

  void _onAccept() {
    widget.permission.request().then(_checkPermission);
  }

  void _onDecline() {
    widget.onDecline();
  }
}
