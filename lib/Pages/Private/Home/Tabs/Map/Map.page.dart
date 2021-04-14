import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Api/Services/MapService.dart';

import '../../../../../Api/Auth.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends GenericRecViewScreen<MapPage> {
  _MapPageState() : super(title: 'Map', hasAppBar: true);
  MapsService mapService = MapsService();

  @override
  void initState() {
    super.initState();
    Auth.getAppToken().then((value) {
      mapService.getMarks(accesToken: value).then((value) {
        print("Getting Valueeeeeeee");
        print(value);
      }).onError((error, stackTrace) {
        print("Im in on error");
        print(error);
      });
    });


  }


  CameraPosition _initialPosition = CameraPosition(target: LatLng(41.4414534,   2.2086006));
  final Completer<GoogleMapController> _controller = Completer();


  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
  @override
  Widget buildPageContent(
    BuildContext context,
    AppState appState,
    UserState userState,
    AppLocalizations localizations,
  ) {
    return Scaffold(
      body: Center(
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: _initialPosition,

        ),
      ),
    );
  }
}
