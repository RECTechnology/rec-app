import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:rec/permissions/permission_data_provider.dart';
import 'package:rec/preferences.dart';

class GoogleMapInstance extends StatefulWidget {
  final Map<MarkerId, Marker> markers;
  final Completer<GoogleMapController> controllerCompleter;
  final Function(GoogleMapController controller) onMapCreated;
  final CameraPositionCallback? cameraMoved;
  final Function? onTap;

  GoogleMapInstance({
    Key? key,
    required this.controllerCompleter,
    required this.onMapCreated,
    this.markers = const {},
    this.onTap,
    this.cameraMoved,
  }) : super(key: key);

  @override
  GoogleMapInstanceState createState() => GoogleMapInstanceState();
}

class GoogleMapInstanceState extends State<GoogleMapInstance> {
  GoogleMapController? controller;

  void centerOnCurrentLocation() async {
    var result = await PermissionDataProvider.location.request();
    if (!result.isGranted) return;

    try {
      var controller = await widget.controllerCompleter.future;
      var location = Location();
      var currentLocation = await location.getLocation();
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0,
            target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
            zoom: 13.0,
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
    widget.controllerCompleter.complete(controller);
    widget.onMapCreated(controller);
  }

  Future<void>? moveCamera(CameraPosition position) {
    return controller?.animateCamera(
      CameraUpdate.newCameraPosition(position),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      padding: EdgeInsets.only(top: 150, left: 4),
      onMapCreated: _onMapCreated,
      markers: Set<Marker>.of(widget.markers.values),
      initialCameraPosition: Preferences.initialCameraPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      buildingsEnabled: true,
      onTap: widget.onTap as void Function(LatLng)?,
      onCameraMove: widget.cameraMoved,
    );
  }
}
