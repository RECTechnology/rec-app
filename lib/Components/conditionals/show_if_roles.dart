import 'package:flutter/material.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

// this could make for a better developer experience
class ShowIfRoles extends StatelessWidget {
  /// List of roles that can view the child widget
  /// If no validRoles passed it means that anyone can see it
  final List<Role> validRoles;
  final Widget child;

  const ShowIfRoles({
    Key? key,
    this.validRoles = const [],
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var canSeeChild = userState.user!.hasRoles(validRoles);

    return canSeeChild ? child : SizedBox.shrink();
  }
}
