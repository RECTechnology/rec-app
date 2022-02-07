import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rec/Api/Interfaces/ApiListResponse.dart';
import 'package:rec/Api/Services/AccountsService.dart';
import 'package:rec/Components/Inputs/text_fields/SearchInput.dart';
import 'package:rec/Components/Inputs/RecFilters.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/Map/MapSearchData.dart';
import 'package:rec/Entities/Forms/RecFilterData.dart';
import 'package:rec/Environments/env.dart';
import 'package:rec/Helpers/ImageHelpers.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/BusinessDraggableSheet.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/CampaignProvider.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';

import 'GoogleMapInstance.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _accountService = AccountsService();
  final _searchData = MapSearchData();
  final _controller = Completer<GoogleMapController>();
  final _mapKey = GlobalKey<GoogleMapInstanceState>();

  /// This will hold information for selected bussines
  /// ie: after a bussines is clicked in the map
  Account _selectedBusiness;

  bool bottomSheetEnabled = false;
  List<RecFilterData<bool>> mapFilters = [];

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
    var localizations = AppLocalizations.of(context);
    var isInCampaign = UserState.of(context).user.hasCampaignAccount();
    var activeCampaign = CampaignProvider.of(context, listen: false).activeCampaign;
    var showLtabFilter = activeCampaign != null && !activeCampaign.isFinished() && isInCampaign;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: _myLocationButton(),
        body: Stack(
          children: [
            GoogleMapInstance(
              key: _mapKey,
              controller: _controller,
              onMapCreated: (_) => _search(),
              onTap: (c) => setState(() => bottomSheetEnabled = false),
              markers: markers,
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
                  filterData: [
                    if (showLtabFilter)
                      RecFilterData<bool>(
                        icon: Icons.check,
                        label: 'TOUCH_HOOD',
                        id: 'TOUCH_HOOD',
                        defaultValue: true,
                        color: Colors.white,
                      ),
                    RecFilterData<bool>(
                      icon: Icons.label,
                      label: 'OFFERS',
                      id: 'OFFERS',
                      defaultValue: false,
                      color: Colors.white,
                    ),
                  ],
                  onChanged: _filtersChanged,
                ),
              ),
            ),
            bottomSheetEnabled ? _bussinesDraggableSheet() : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _bussinesDraggableSheet() {
    return BusinessDraggableSheet(business: _selectedBusiness);
  }

  Widget _myLocationButton() {
    return bottomSheetEnabled
        ? null
        : FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () => _mapKey.currentState.centerOnCurrentLocation(),
            elevation: 1,
            child: Icon(Icons.my_location, color: Brand.grayDark),
          );
  }

  Future<bool> _onWillPop() async {
    setState(() => bottomSheetEnabled = false);
    return false;
  }

  void _search() {
    _accountService.search(_searchData).then(_onSearchResults).catchError(_onError);
  }

  void _onSearchResults(ApiListResponse<Account> value) {
    if (value.items.isEmpty) return _noSearchFound();
    _setMarks(value.items);
  }

  void _noSearchFound() {
    var localizations = AppLocalizations.of(context);
    RecToast.showInfo(context, localizations.translate('NON_SEARCH_RESULT'));
    _setMarks([]);
  }

  Future<void> _getBussineData(String id) async {
    await _accountService
        .getOne(id)
        .then((value) => _selectedBusiness = value)
        .catchError(_onError);
  }

  void _onError(err) {
    RecToast.showError(context, err.message);
  }

  void _setCustomMapPin() async {
    markerIcon = BitmapDescriptor.fromBytes(
      await ImageHelpers.getBytesFromAsset('assets/marcador.png', 50),
    );

    markerLtab = BitmapDescriptor.fromBytes(
      await ImageHelpers.getBytesFromAsset('assets/marker-ltab.png', 50),
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
          position: account.getLatLong(),
          icon: account.isInLtabCampaign ? markerLtab : markerIcon,
          onTap: () => _bussinessTapped(accountId),
        );
      }
    });
  }

  void _bussinessTapped(String id) {
    _getBussineData(id).then(_openModalBottomSheet);
  }

  void _openModalBottomSheet(value) {
    setState(() => bottomSheetEnabled = true);
  }

  void _filtersChanged(Map<String, bool> map) {
    if (map.containsKey('OFFERS')) {
      _setOnlyWithOffers(map['OFFERS']);
    }

    if (map.containsKey('TOUCH_HOOD')) {
      _setLtab(map['TOUCH_HOOD']);
    }

    _search();
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
