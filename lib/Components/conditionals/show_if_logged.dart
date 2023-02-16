import 'package:flutter/material.dart';
import 'package:rec/providers/user_state.dart';

class ShowIfLoggedIn extends StatelessWidget {
  final Widget child;

  const ShowIfLoggedIn({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userState = UserState.of(context);
    final loggedIn = userState.user != null;

    return loggedIn ? child : SizedBox.shrink();
  }
}
