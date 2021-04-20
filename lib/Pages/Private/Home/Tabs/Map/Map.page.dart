import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rec/Api/Services/MapService.dart';
import 'package:rec/Entities/Map/MapSearchData.dart';
import 'package:rec/Entities/Marck.ent.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapsService mapService = MapsService();
  MapSearchData searchData = MapSearchData(search: 'Ferrete', limit: 1);
  BitmapDescriptor markerIcon;

  final Set<Marker> _markers = {};
  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(41.4414534, 2.2086006),
    zoom: 12,
  );
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                  child: TextField(
                decoration: InputDecoration(hintText: 'offset'),
                onChanged: setSearch,
              )),
              PopupMenuItem(
                  child: TextField(
                decoration: InputDecoration(hintText: 'only_with_offers'),
                // onChanged: setOnlyWithOffers,
              )),
              PopupMenuItem(
                  child: TextField(
                decoration: InputDecoration(hintText: 'type'),
                onChanged: setType,
              )),
              PopupMenuItem(
                  child: TextField(
                decoration: InputDecoration(hintText: 'limit'),
                // onChanged: setLimit,
              )),
              PopupMenuItem(
                  child: TextField(
                decoration: InputDecoration(hintText: 'search'),
                onChanged: setSearch,
              )),
              PopupMenuItem(
                  child: TextField(
                decoration: InputDecoration(hintText: 'sort'),
                onChanged: setSort,
              )),
              PopupMenuItem(
                  child: TextField(
                decoration: InputDecoration(hintText: 'order'),
                onChanged: setOrder,
              )),
              PopupMenuItem(
                  child: TextField(
                decoration: InputDecoration(hintText: 'subtype'),
                onChanged: setSubType,
              )),
              PopupMenuItem(
                  child: TextField(
                decoration: InputDecoration(hintText: 'offset'),
                // onChanged: setOffset,
              )),
            ],
          ),
        ],
      ),
      body: Center(
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          markers: _markers,
          initialCameraPosition: _initialPosition,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    mapService
        .getMarks(searchData)
        .then((value) => setMarks(value.items))
        .onError((error, stackTrace) {
      print(error);
    });
  }

  void goToDetailsPage() {
    print('Going to details page...');
  }

  void setCustomMapPin() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/marcador.png',
    );
  }

  void setMarks(List<Marck> marks) {
    setState(() {
      for (var element in marks) {
        _markers.add(
          Marker(
            markerId: MarkerId(element.id.toString()),
            position: LatLng(element.lat, element.long),
            infoWindow: InfoWindow(
              title: element.name,
            ),
            onTap: goToDetailsPage,
          ),
        );
      }
    });
  }

  void setSearch(String search) {
    searchData.search = search;
  }

  void setOffset(int offset) {
    searchData.offset = offset;
  }

  void setOnMap(bool onMap) {
    searchData.onMap = onMap;
  }

  void setOnlyWithOffers(bool onlyWithOffers) {
    searchData.onlyWithOffers = onlyWithOffers;
  }

  void setType(String type) {
    searchData.type = type;
  }

  void setSubType(String subType) {
    searchData.subType = subType;
  }

  void setLimit(int limit) {
    searchData.limit = limit;
  }

  void setSort(String sort) {
    searchData.sort = sort;
  }

  void setOrder(String order) {
    searchData.order = order;
  }
}
