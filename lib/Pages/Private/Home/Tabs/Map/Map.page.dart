import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Api/Services/MapService.dart';
import 'package:rec/Entities/Marck.ent.dart';

import '../../../../../Api/Auth.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends GenericRecViewScreen<MapPage> {
  _MapPageState() : super(title: 'Map', hasAppBar: true);
  MapsService mapService = MapsService();

  String search;
  String on_map;
  String only_with_offers;
  String type;
  String subType;
  String limit;
  String sort;
  String order;
  String offset;
  BitmapDescriptor pinLocationIcon;

  @override
  void initState() {
    super.initState();
    setCustomMapPin();

  }

  final Set<Marker> _markers = {};

  final CameraPosition _initialPosition =
      CameraPosition(target: LatLng(41.4414534, 2.2086006),zoom: 12);
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget buildPageContent(
    BuildContext context,
    AppState appState,
    UserState userState,
    AppLocalizations localizations,
  ) {
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
                onChanged: setOnly_with_offers,
              )),
              PopupMenuItem(
                  child: TextField(
                decoration: InputDecoration(hintText: 'type'),
                onChanged: setType,
              )),
              PopupMenuItem(
                  child: TextField(
                decoration: InputDecoration(hintText: 'limit'),
                onChanged: setLimit,
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
                onChanged: setOffset,
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
    setState(() {
      List<Marck> marcks;
      Auth.getAccessToken().then((value) {
        mapService
            .getMarks(
                accesToken: value,
                on_map: on_map,
                only_with_offers: only_with_offers,
                search: search,
                subtype: subType,
                type: type,
                limit: limit,
                offSet: offset,
                order: order)
            .then((value) {
          marcks = value.items ;
          for (var element in marcks) {

            _markers.add(Marker(
                markerId: MarkerId(element.id.toString()),
                position: LatLng(element.lat,element.long),
                ));

          }
        }).onError((error, stackTrace) {
        });
      });
    });
  }
  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/marcador.png');
  }

  void setSearch(String search) {
    this.search = search;
  }

  void setOffset(String offset) {
    this.offset = offset;
  }

  void seton_map(String on_map) {
    this.on_map = on_map;
  }

  void setOnly_with_offers(String only_with_offers) {
    this.only_with_offers = only_with_offers;
  }

  void setType(String type) {
    this.type = type;
  }

  void setSubType(String subType) {
    this.subType = subType;
  }

  void setLimit(String limit) {
    this.limit = limit;
  }

  void setSort(String sort) {
    this.sort = sort;
  }

  void setOrder(String order) {
    this.order = order;
  }
}
