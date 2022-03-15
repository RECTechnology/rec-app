import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rec/Components/Inputs/text_fields/SearchInput.dart';
import 'package:rec/helpers/map_markers.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/business_draggable_sheet.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/google_map_instance.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/map_filters.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class MapPage extends StatefulWidget {
  MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapSearchData _searchData = MapSearchData();
  final _accountService = AccountsService(env: env);
  final _controller = Completer<GoogleMapController>();
  final _mapKey = GlobalKey<GoogleMapInstanceState>();

  /// This will hold information for selected bussines
  /// ie: after a bussines is clicked in the map
  Account? _selectedBusiness;

  bool _bottomSheetEnabled = false;
  bool _isLoading = false;

  // Google maps stuff
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    // Set culture campaignCode if active
    var cultureCampaign = CampaignProvider.deaf(context).getCampaignByCode(env.CMP_CULT_CODE);
    if (cultureCampaign!.isStarted() && !cultureCampaign.isFinished()) {
      _searchData.campaignCode = env.CMP_CULT_CODE;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

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
              onTap: (c) => setState(() => _bottomSheetEnabled = false),
              markers: markers,
            ),
            Positioned(
              top: 42,
              right: 16,
              left: 16,
              child: SearchInput(
                hintText: localizations!.translate('SEARCH_HERE'),
                shaded: true,
                borderRadius: 100,
                isLoading: _isLoading,
                fieldSubmited: (val) {
                  _searchData.setSearch(val);
                  _search();
                },
              ),
            ),
            Positioned(
              top: 100,
              right: 0,
              left: 0,
              child: MapFilters(
                searchData: _searchData,
                onChange: (data) {
                  setState(() {
                    _searchData.copyFrom(data);
                  });
                  _search();
                },
              ),
            ),
            _bottomSheetEnabled ? BusinessDraggableSheet(business: _selectedBusiness) : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget? _myLocationButton() {
    return _bottomSheetEnabled
        ? null
        : FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () => _mapKey.currentState!.centerOnCurrentLocation(),
            elevation: 1,
            child: Icon(Icons.my_location, color: Brand.grayDark),
          );
  }

  Future<bool> _onWillPop() async {
    setState(() => _bottomSheetEnabled = false);
    return false;
  }

  void _search() async {
    if (!MapMarkers.hasLoaded) {
      await MapMarkers.loadMarkers();
    }

    _isLoading = true;

    await _accountService.search(_searchData).then(_onSearchResults).catchError(_onError);
  }

  void _onSearchResults(ApiListResponse<MapAccountData> value) {
    if (value.items!.isEmpty) return _noSearchFound();

    _isLoading = false;
    _createMarkersForAccounts(value.items);
  }

  void _noSearchFound() {
    RecToast.showInfo(context, 'NON_SEARCH_RESULT');

    _isLoading = false;
    _createMarkersForAccounts([]);
  }

  Future<void> _getBussiness(String id) async {
    await _accountService
        .getOne(id)
        .then((value) => _selectedBusiness = value)
        .catchError(_onError);
  }

  _onError(err) {
    RecToast.showError(context, err.message);
  }

  void _createMarkersForAccounts(List<MapAccountData>? accounts) {
    setState(() {
      markers = {};

      for (var account in accounts!) {
        var accountId = account.id!;
        var markerId = MarkerId(accountId);
        var marker = MapMarkers.getMarkerForAccount(account, context);

        markers[markerId] = Marker(
          markerId: MarkerId(account.id.toString()),
          position: LatLng(account.latitude ?? 0.0, account.longitude ?? 0.0),
          icon: (marker ?? MapMarkers.markerNormal) as BitmapDescriptor,
          onTap: () => _bussinessTapped(accountId),
        );
      }
    });
  }

  void _bussinessTapped(String id) {
    _getBussiness(id).then(_openModalBottomSheet);
  }

  void _openModalBottomSheet(value) {
    setState(() => _bottomSheetEnabled = true);
  }
}
