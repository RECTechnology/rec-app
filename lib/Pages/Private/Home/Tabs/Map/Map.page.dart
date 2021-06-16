import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rec/Api/Services/AccountsService.dart';
import 'package:rec/Components/Inputs/SearchInput.dart';
import 'package:rec/Components/Inputs/RecFilters.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/Map/MapSearchData.dart';
import 'package:rec/Entities/RecFilterData.dart';
import 'package:rec/Environments/env.dart';
import 'package:rec/Helpers/ImageHelpers.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/DetailsPage/Details.page.dart';
import 'package:rec/Permissions/PermissionProviders.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/BoxDecorations.dart';
import 'package:rec/brand.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rec/preferences.dart';

// TODO: Clean this page up, it's messy and way to big
class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final AccountsService _accountService = AccountsService();
  final MapSearchData _searchData = MapSearchData();
  final Completer<GoogleMapController> _controller = Completer();

  bool bottomSheetEnabled = false;

  /// This will hold information for selected bussines
  /// ie: after a bussines is clicked in the map
  Account _selectedBusiness;

  List<RecFilterData<bool>> recFilters = [];
  List<Widget> bottomSheetList = [];

  // Google maps stuff
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor markerIcon;
  BitmapDescriptor markerLtab;

  @override
  void initState() {
    super.initState();
    _setCustomMapPin();
  }

  @override
  Widget build(BuildContext context) {
    _addFiltersButtons();
    return _content();
  }

  Widget _content() {
    var localizations = AppLocalizations.of(context);
    var markerValues = Set<Marker>.of(markers.values);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: _myLocationButton(),
        body: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(top: 150, left: 4),
              onMapCreated: _onMapCreated,
              markers: markerValues.where((element) => element != null).toSet(),
              initialCameraPosition: Preferences.initialCameraPosition,
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
                  _setSearch(val);
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
                    if (map.containsKey('OFFERS')) {
                      _setOnlyWithOffers(map['OFFERS']);
                    }

                    if (map.containsKey('TOUCH_HOOD')) {
                      _setLtab(map['TOUCH_HOOD']);
                    }

                    _search();
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
              padding: EdgeInsets.zero,
              itemCount: 1,
              controller: scrollController,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 108,
                  child: DetailsPage(_selectedBusiness),
                );
              },
            ),
          ),
        );

        return Container(
          decoration: BoxDecorations.create(
            color: Colors.white,
            blurRadius: 15,
            offset: Offset(0, 40),
          ),
          child: ListView.builder(
            padding: EdgeInsets.zero,
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

  Widget _myLocationButton() {
    return bottomSheetEnabled
        ? null
        : FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: _centerOnCurrentLocation,
            elevation: 1,
            child: Icon(Icons.my_location, color: Brand.grayDark),
          );
  }

  Future<bool> _onWillPop() async {
    setState(() => bottomSheetEnabled = false);
    return false;
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
    _accountService
        .search(_searchData)
        .then((value) => _setMarks(value.items))
        .onError((error, stackTrace) => print(error));
  }

  void _addFiltersButtons() {
    var localizations = AppLocalizations.of(context);
    recFilters = [
      // RecFilterData<bool>(
      //   icon: Icons.check,
      //   label: localizations.translate('OFFERS'),
      //   id: 'OFFERS',
      //   defaultValue: false,
      //   color: Colors.white,
      // ),
      RecFilterData<bool>(
        icon: Icons.check,
        label: localizations.translate('TOUCH_HOOD'),
        id: 'TOUCH_HOOD',
        defaultValue: true,
        color: Colors.white,
      ),
    ];
  }

  Future<void> _getBussineData(String id) async {
    await _accountService
        .getOne(id)
        .then((value) => _selectedBusiness = value)
        // ignore: return_of_invalid_type_from_catch_error
        .catchError((err) => RecToast.showError(context, err.message));
  }

  void _openModalBottomSheet(value) {
    setState(() => bottomSheetEnabled = true);
  }

  void _setCustomMapPin() async {
    markerIcon = BitmapDescriptor.fromBytes(
      await ImageHelpers.getBytesFromAsset(
        'assets/marcador.png',
        70,
      ),
    );

    markerLtab = BitmapDescriptor.fromBytes(
      await ImageHelpers.getBytesFromAsset(
        'assets/marker-ltab.png',
        70,
      ),
    );
  }

  void _setMarks(List<Account> accounts) {
    setState(() {
      markers = {};

      for (var account in accounts) {
        var accountId = account.id;
        var markerId = MarkerId(accountId);

        markers[markerId] = Marker(
          markerId: MarkerId(account.id.toString()),
          position: LatLng(
            account.latitude,
            account.longitude,
          ),
          icon: account.isInLtabCampaign ? markerLtab : markerIcon,
          onTap: () => _bussinessTapped(accountId),
        );
      }
    });
  }

  void _bussinessTapped(String id) {
    _getBussineData(id).then(_openModalBottomSheet);
  }

  void _setLtab(bool state) {
    setState(() {
      _searchData.campaign = state ? env.CAMPAIGN_ID : null;
    });
  }

  void _setSearch(String search) {
    _searchData.search = search;
  }

  void _setOnlyWithOffers(bool onlyWithOffers) {
    setState(() {
      _searchData.onlyWithOffers = onlyWithOffers;
    });
  }
}
