import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rec/Api/Services/AccountsService.dart';
import 'package:rec/Components/Inputs/SearchInput.dart';
import 'package:rec/Components/RecFilters.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/Map/MapSearchData.dart';
import 'package:rec/Entities/RecFilterData.dart';
import 'package:rec/Helpers/ImageHelpers.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/DetailsPage/Details.page.dart';
import 'package:rec/Permissions/PermissionProviders.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/BoxDecorations.dart';
import 'package:rec/brand.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  AccountsService accountService = AccountsService();
  MapSearchData searchData = MapSearchData();
  List<RecFilterData<bool>> recFilters = [];
  String selectedAccountId;

  bool bottomSheetEnabled = false;
  Account account;
  List<Widget> bottomSheetList = [];

  // Google maps stuff
  Set<Marker> _markerList = {};
  BitmapDescriptor markerIcon;
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
    addFiltersButtons();
    return _content();
  }

  Widget _content() {
    var localizations = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () async {
        setState(() => bottomSheetEnabled = false);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: bottomSheetEnabled
            ? null
            : FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: _centerOnCurrentLocation,
                elevation: 1,
                child: Icon(Icons.my_location, color: Brand.grayDark),
              ),
        body: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(top: 150, left: 4),
              onMapCreated: _onMapCreated,
              markers: _markerList,
              initialCameraPosition: _initialPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              buildingsEnabled: true,
              onTap: (c) {
                setState(() => bottomSheetEnabled = false);
              },
            ),
            Positioned(
              top: 42,
              right: 16,
              left: 16,
              child: SearchInput(
                hintText: localizations.translate('SEARCH_HERE'),
                shaded: true,
                borderRadius: 100,
                fieldSubmited: (val) {
                  setSearch(val);
                  _search();
                },
              ),
            ),
            Positioned(
              top: 100,
              right: 16,
              left: 16,
              child: Container(
                child: RecFilters(
                  filterData: recFilters,
                  onChanged: (Map<String, bool> map) {
                    setOnlyWithOffers(map['OFFERS']);
                  },
                ),
              ),
            ),
            bottomSheetEnabled ? _bussinesDraggableSheet() : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _greyBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(8.0),
          width: 60,
          height: 5,
          decoration: BoxDecoration(
            color: Brand.grayLight2,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
    );
  }

  Widget _bussinesDraggableSheet() {
    return DraggableScrollableSheet(
      maxChildSize: 0.95,
      minChildSize: 0.18,
      initialChildSize: 0.2,
      builder: (
        BuildContext context,
        ScrollController scrollController,
      ) {
        bottomSheetList.clear();
        bottomSheetList.add(_greyBar());
        bottomSheetList.add(
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 56,
            child: ListView.builder(
              itemCount: 1,
              controller: scrollController,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 108,
                  child: DetailsPage(account),
                );
              },
            ),
          ),
        );

        return Container(
          decoration: BoxDecorations.create(
            color: Colors.transparent,
            blurRadius: 15,
            offset: Offset(0, 40),
          ),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            controller: scrollController,
            itemCount: bottomSheetList.length,
            itemBuilder: (context, index) {
              return bottomSheetList[index];
            },
          ),
        );
      },
    );
  }

  void _centerOnCurrentLocation() async {
    var result = await PermissionProviders.location.request();
    if (!result.isGranted) return;

    var controller = await _controller.future;
    var location = Location();

    try {
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
      // ignore: empty_catches
    } catch (e) {
      print(e);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    _search();
  }

  void _search() {
    accountService.search(searchData).then((value) {
      setMarks(value.items);
    }).onError(
      (error, stackTrace) {
        print(error);
      },
    );
  }

  void addFiltersButtons() {
    var localizations = AppLocalizations.of(context);
    recFilters = [
      RecFilterData<bool>(
        icon: Icons.check,
        label: localizations.translate('OFFERS'),
        id: 'OFFERS',
        defaultValue: false,
        color: Colors.white,
      ),
      RecFilterData<bool>(
        icon: Icons.check,
        label: localizations.translate('TOUCH_HOOD'),
        id: 'TOUCH_HOOD',
        defaultValue: false,
        color: Colors.white,
      ),
    ];
  }

  Future<void> getBussineData() async {
    await accountService
        .getOne(selectedAccountId)
        .then((value) => account = value)
        // ignore: return_of_invalid_type_from_catch_error
        .catchError((err) => RecToast.showError(context, err.message));
  }

  Future<void> openModalBottomSheet() async {
    await getBussineData().then(
      (value) {
        setState(() => bottomSheetEnabled = true);
      },
    );
  }

  void setCustomMapPin() async {
    markerIcon = BitmapDescriptor.fromBytes(
      await ImageHelpers.getBytesFromAsset(
        'assets/marcador.png',
        70,
      ),
    );
  }

  void setMarks(List<Account> accounts) {
    setState(() {
      _markerList = {};
      for (var element in accounts) {
        _markerList.add(
          Marker(
            markerId: MarkerId(element.id.toString()),
            position: LatLng(
              element.latitude,
              element.longitude,
            ),
            icon: markerIcon,
            onTap: () {
              selectedAccountId = element.id.toString();
              openModalBottomSheet();
            },
          ),
        );
      }
    });
  }

  void setSearch(String search) {
    searchData.search = search;
  }

  void setOnlyWithOffers(bool onlyWithOffers) {
    setState(() {
      searchData.onlyWithOffers = onlyWithOffers;
      _search();
    });
  }
}
