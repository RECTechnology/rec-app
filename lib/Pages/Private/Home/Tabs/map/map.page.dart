import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rec/Components/Inputs/text_fields/SearchInput.dart';
import 'package:rec/Pages/Private/Home/Tabs/map/business_draggable_sheet.dart';
import 'package:rec/Pages/Private/Home/Tabs/map/google_map_instance.dart';
import 'package:rec/Pages/Private/Home/Tabs/map/map_filters.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/map_markers.dart';
import 'package:rec/mixins/loadable_mixin.dart';
import 'package:rec/preferences.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class MapPage extends StatefulWidget {
  MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with StateLoading {
  final _searchData = MapSearchData();
  final _accountService = AccountsService(env: env);
  final _controllerCompleter = Completer<GoogleMapController>();
  final _mapKey = GlobalKey<GoogleMapInstanceState>();
  var _currentCameraPosition = Preferences.initialCameraPosition;

  /// This will hold information for selected bussines
  /// ie: after a bussines is clicked in the map
  Account? _selectedBusiness;

  /// Whether to show the bottom sheet (this is true when a user presses on a marker)
  bool _bottomSheetEnabled = false;

  // Holds all the markers
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    // Set culture campaignCode if active
    final cultureCampaign = CampaignProvider.deaf(context).getCampaignByCode(env.CMP_CULT_CODE);
    if (cultureCampaign != null && cultureCampaign.isStarted() && !cultureCampaign.isFinished()) {
      _searchData.campaignCode = env.CMP_CULT_CODE;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: _myLocationButton(),
        body: Stack(
          children: [
            GoogleMapInstance(
              key: _mapKey,
              controllerCompleter: _controllerCompleter,
              onMapCreated: (controller) => _search(),
              onTap: (c) => setState(() => _bottomSheetEnabled = false),
              cameraMoved: (position) {
                _currentCameraPosition = position;
              },
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
                isLoading: isLoading,
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
            _bottomSheetEnabled
                ? BusinessDraggableSheet(
                    business: _selectedBusiness,
                    isLoading: isLoading,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget? _myLocationButton() {
    final recTheme = RecTheme.of(context);

    return _bottomSheetEnabled
        ? null
        : FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () => _mapKey.currentState!.centerOnCurrentLocation(),
            elevation: 1,
            child: Icon(Icons.my_location, color: recTheme!.grayDark),
          );
  }

  Future<bool> _onWillPop() async {
    setState(() => _bottomSheetEnabled = false);
    return false;
  }

  void _search() async {
    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();

    if (!MapMarkers.hasLoaded) {
      await MapMarkers.loadMarkers(RecTheme.of(context)!.assets);
    }

    startLoading();

    await _accountService.search(_searchData).then(_onSearchResults).catchError(_onError);
  }

  void _onSearchResults(ApiListResponse<MapAccountData> value) {
    if (!mounted) return;

    if (value.items.isEmpty) return _noSearchFound();

    stopLoading();
    _createMarkersForAccounts(value.items).then((_) {
      if (value.items.length == 1) {
        _centerOnAccount(value.items.first);
      }
    });
  }

  void _noSearchFound() {
    RecToast.showInfo(context, 'NON_SEARCH_RESULT');

    stopLoading();
    _createMarkersForAccounts([]);
  }

  void _centerOnAccount(MapAccountData? account) {
    if (account == null) return;

    _mapKey.currentState?.moveCamera(
      CameraPosition(
        target: LatLng(
          account.latitude ?? _currentCameraPosition.target.latitude,
          account.longitude ?? _currentCameraPosition.target.longitude,
        ),
        zoom: _currentCameraPosition.zoom,
      ),
    );
  }

  Future<void> _getBussiness(String id) async {
    startLoading();
    await _accountService
        .getOne(id)
        .then((value) => _selectedBusiness = value)
        .catchError(_onError);
    stopLoading();
  }

  _onError(err) {
    if (!mounted) return;
    stopLoading();
    RecToast.showError(context, err.toString());
  }

  Future _createMarkersForAccounts(List<MapAccountData>? accounts) async {
    final Map<MarkerId, Marker> newMarkers = {};

    for (final account in accounts!) {
      final accountId = account.id!;
      final markerId = MarkerId(accountId);
      final marker = MapMarkers.getMarkerForAccount(account, context);

      newMarkers[markerId] = Marker(
        markerId: markerId,
        position: LatLng(account.latitude ?? 0.0, account.longitude ?? 0.0),
        icon: (marker ?? MapMarkers.markerNormal) as BitmapDescriptor,
        onTap: () => _bussinessTapped(accountId),
      );
    }

    setState(() {
      markers = newMarkers;
    });

    /// This is needed until it's fixed on Flutter's side
    /// If we did not update the camera position, the markers did not update
    ///
    /// Fix found in: https://github.com/flutter/flutter/issues/103686
    await _mapKey.currentState?.moveCamera(
      CameraPosition(
        target: _currentCameraPosition.target,
        zoom: _currentCameraPosition.zoom + 0.005,
      ),
    );

    await _mapKey.currentState?.moveCamera(
      CameraPosition(
        target: _currentCameraPosition.target,
        zoom: _currentCameraPosition.zoom - 0.005,
      ),
    );
  }

  void _bussinessTapped(String id) {
    _openModalBottomSheet();
    _getBussiness(id);
  }

  void _openModalBottomSheet() {
    setState(() => _bottomSheetEnabled = true);
  }
}
