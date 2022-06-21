import 'package:flutter/material.dart';

/// Displays a button that will pop the current route
class ClosePageButton extends StatelessWidget {
  /// Overrides default close behavior
  final void Function()? closeAction;

  /// Icon to be shown, defaults to [Icons.clear]
  final Widget? icon;

  const ClosePageButton({
    Key? key,
    this.closeAction,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon ??
          Icon(
            Icons.clear,
            color: Colors.black,
          ),
      onPressed: closeAction ??
          () {
            Navigator.of(context).pop();
          },
    );
  }
}
