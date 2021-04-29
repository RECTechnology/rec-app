import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rec/Permissions/PermissionProvider.dart';

class ContactsPermissionProvider extends PermissionProvider {
  ContactsPermissionProvider()
      : super(
          Permission.contacts,
          icon: Icons.import_contacts_outlined,
          title: 'CONTACTS_PERMISSION_TITLE',
          subtitle: 'CONTACTS_PERMISSION_SUBTITLE',
          buttonAcceptText: 'CONTACTS_PERMISSION_ACCEPT',
          buttonDeclineText: 'CONTACTS_PERMISSION_DECLINE',
        );
}
