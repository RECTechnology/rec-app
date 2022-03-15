import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/DropDown.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

typedef ValueChangedDynamic<T> = dynamic Function(T?);

class RoleSelector extends StatefulWidget {
  final bool isDense;
  final BoxDecoration? decoration;
  final String? role;
  final ValueChangedDynamic<String>? onChanged;
  final EdgeInsets? padding;

  RoleSelector({
    Key? key,
    this.isDense = true,
    this.decoration,
    this.role,
    this.onChanged,
    this.padding,
  }) : super(key: key);

  @override
  _RoleSelectorState createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<RoleSelector> {
  @override
  Widget build(BuildContext context) {
    return DropDown(
      title: 'ROLE',
      current: widget.role,
      isDense: widget.isDense,
      decoration: widget.decoration,
      onSelect: widget.onChanged,
      data: AccountPermission.selectableRoles,
      padding: widget.padding,
    );
  }
}
