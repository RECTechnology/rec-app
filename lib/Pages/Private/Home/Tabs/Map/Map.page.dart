import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rec/Api/Services/MapService.dart';
import 'package:rec/Api/Services/BussinesDataService.dart';
import 'package:rec/Entities/Map/MapSearchData.dart';
import 'package:rec/Entities/Marck.ent.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/Components/RecFiltterButton.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'DetailsPage/Details.page.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapsService mapService = MapsService();
  BussinesDataService bussinesDataService = BussinesDataService();
  MapSearchData searchData = MapSearchData();
  BitmapDescriptor markerIcon;
  int activeFilttersCount = 0;
  final Set<Marker> _markers = {};
  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(41.4414534, 2.2086006),
    zoom: 12,
  );
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor customIcon1;

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
  }

  List<IconData> icons = [
    Icons.ac_unit,
    Icons.account_balance,
    Icons.adb,
    Icons.add_photo_alternate,
    Icons.format_line_spacing
  ];

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              markers: _markers,
              initialCameraPosition: _initialPosition,
            ),
            Positioned(
              top: 30.0,
              right: 15.0,
              left: 15.0,
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar aquí',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                      suffixIcon: IconButton(
                          icon: IconButton(
                        icon: Icon(Icons.search),
                        iconSize: 30.0,
                      )),
                    ),
                    onChanged: (val) {
                      setState(() {
                        setSearch(val);
                      });
                    }),
              ),
            )
          ],
        ),
        bottomSheet: Container(
          height: 72,
          child: Column(
            children: [
              Padding(
                padding: Paddings.hint,
                child: Center(
                    child: Container(
                  width: 60,
                  height: 5,
                  child: RaisedButton(
                    color: Colors.grey,
                  ),
                )),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                child: Row(
                  children: [
                    Text(
                      localizations.translate('FILTERS'),
                      style: TextStyle(
                          color: activeFilttersCount != 0
                              ? Colors.deepOrange
                              : Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    RecFiltterButton(
                      icon: Icons.add,
                      label: localizations.translate('OFFERS'),
                      padding: Paddings.filterButton,
                      onPressed: setOnlyWithOffers,
                      disabled: false,
                      backgroundColor: searchData.onlyWithOffers == true
                          ? Colors.orange[100]
                          : Colors.white,
                    ),
                    RecFiltterButton(
                      icon: Icons.add,
                      label: localizations.translate('TOUCH_HOOD'),
                      padding: Paddings.filterButton,
                      onPressed: () {
                        setSearch('Li toca al barri');
                      },
                      disabled: false,
                      backgroundColor: searchData.search.isNotEmpty
                          ? Colors.orange[100]
                          : Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    mapService
        .getMarks(searchData)
        .then((value) => setMarks(value.items))
        .onError(
      (error, stackTrace) {
        print(error);
      },
    );
  }

  void getDetailsPage(String id) {
    print("Im going to bussines data serviceeeeeeeeeeeeeeeee");
    print(id);
    bussinesDataService.getData(id).then((value) {
      print("Printing value in Map pageeeeeeeeeeeeeeeeeeeeee");
      print(value);
      showCupertinoModalBottomSheet<dynamic>(
        expand: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => DetailsPage(value),
      );
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
    ImageConfiguration configuration = createLocalImageConfiguration(context);

    BitmapDescriptor.fromAssetImage(configuration, 'assets/marker.svg')
        .then((icon) {
      setState(() {
        customIcon1 = icon;
        setState(() {
          for (var element in marks) {
            _markers.add(
              Marker(
                markerId: MarkerId(element.id.toString()),
                position: LatLng(element.lat, element.long),
                icon: customIcon1,
                infoWindow: InfoWindow(
                  title: element.name,
                ),
                onTap: () {
                  getDetailsPage(element.id.toString());
                },
              ),
            );
          }
        });
      });
    });

  }

  void setSearch(String search) {
    print(searchData.search.length);
    if (searchData.search.length == 0) {
      searchData.search = search;
      activeFilttersCount++;
    } else {
      searchData.search = '';
      activeFilttersCount--;
    }
    setState(() {});
  }

  void setOffset(int offset) {
    searchData.offset = offset;
  }

  void setOnMap(bool onMap) {
    searchData.onMap = onMap;
  }

  void setOnlyWithOffers() {
    print("Im in setOnlyWithOffers");
    print(searchData.onlyWithOffers);
    if (searchData.onlyWithOffers == true) {
      searchData.onlyWithOffers = false;
      activeFilttersCount++;
    } else {
      searchData.onlyWithOffers = true;
      activeFilttersCount--;
    }
    setState(() {});
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
