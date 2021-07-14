import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:rec/Permissions/PermissionProviders.dart';
import 'package:rec/preferences.dart';

class GoogleMapInstance extends StatefulWidget {
  final Map<MarkerId, Marker> markers;
  final Completer<GoogleMapController> controller;
  final Function(GoogleMapController controller) onMapCreated;
  final Function onTap;

  GoogleMapInstance({
    Key key,
    @required this.controller,
    @required this.onMapCreated,
    this.markers = const {},
    this.onTap,
  }) : super(key: key);

  @override
  GoogleMapInstanceState createState() => GoogleMapInstanceState();
}

class GoogleMapInstanceState extends State<GoogleMapInstance> {
  void centerOnCurrentLocation() async {
    var result = await PermissionProviders.location.request();
    if (!result.isGranted) return;

    try {
      var controller = await widget.controller.future;
      var location = Location();
      var currentLocation = await location.getLocation();
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0,
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: 13.0,
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    widget.controller.complete(controller);
    widget.onMapCreated(controller);
  }

  @override
  Widget build(BuildContext context) {
    var markerValues = Set<Marker>.of(widget.markers.values);

    return GoogleMap(
      padding: EdgeInsets.only(top: 150, left: 4),
      onMapCreated: _onMapCreated,
      markers: markerValues.where((element) => element != null).toSet(),
      initialCameraPosition: Preferences.initialCameraPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      buildingsEnabled: true,
      onTap: widget.onTap,
    );
  }
}
