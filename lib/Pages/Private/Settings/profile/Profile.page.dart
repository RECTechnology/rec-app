import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Base/screens/GenericRecEditScreen.dart';
import 'package:rec/Components/Forms/profile.form.dart';
import 'package:rec/Providers/AppState.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends GenericRecEditScreen<ProfilePage> {
  _ProfilePageState() : super(title: 'Profile', hasAppBar: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildPageContent(BuildContext context, AppState appState) {
    return ProfileForm();
  }
}
