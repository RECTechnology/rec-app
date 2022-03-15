import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/SelectableChip.dart';
import 'package:rec/Components/Layout/horizontal_list_layout.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/more_filters_page.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class MapFilters extends StatefulWidget {
  final MapSearchData searchData;
  final ValueChanged<MapSearchData>? onChange;

  MapFilters({
    Key? key,
    required this.searchData,
    this.onChange,
  }) : super(key: key);

  @override
  _MapFiltersState createState() => _MapFiltersState();
}

class _MapFiltersState extends State<MapFilters> {
  MapSearchData get searchData => widget.searchData;

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var campaignProvider = CampaignProvider.of(context);
    var user = UserState.of(context).user;

    var isInLtabCampaign = user!.getCampaignAccount(env.CMP_LTAB_CODE) != null;
    var ltabCampaign = campaignProvider.getCampaignByCode(env.CMP_LTAB_CODE);
    var cultureCampaign = campaignProvider.getCampaignByCode(env.CMP_CULT_CODE);

    var showLtabFilter = ltabCampaign != null &&
        ltabCampaign.isStarted() &&
        !ltabCampaign.isFinished() &&
        isInLtabCampaign;
    var showCultureFilter =
        cultureCampaign != null && cultureCampaign.isStarted() && !cultureCampaign.isFinished();

    return Container(
      height: 40,
      child: HorizontalList(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          SelectableChip(
            label: 'OFFERS',
            isSelected: searchData.onlyWithOffers == true,
            onSelected: (value) {
              widget.onChange!(
                searchData..onlyWithOffers = value,
              );
            },
          ),
          if (showLtabFilter)
            SelectableChip(
              label: 'title.link_ltab',
              isSelected: searchData.campaignCode == env.CMP_LTAB_CODE,
              onSelected: (value) {
                widget.onChange!(
                  searchData..campaignCode = value ? env.CMP_LTAB_CODE : null,
                );
              },
            ),
          if (showCultureFilter)
            SelectableChip(
              label: 'REC_CULTURAL',
              isSelected: searchData.campaignCode == env.CMP_CULT_CODE,
              onSelected: (value) {
                widget.onChange!(
                  searchData..campaignCode = value ? env.CMP_CULT_CODE : null,
                );
              },
            ),
          ActionChip(
            label: LocalizedText(
              searchData.activity == null ? 'MORE' : 'MORE_FILTERS',
              params: {
                'selected':
                    '(${searchData.activity == null ? '' : searchData.activity!.getNameForLocale(localizations!.locale)})',
              },
              style: TextStyle(
                color: searchData.activity != null ? Brand.accentColor : Brand.grayDark2,
                fontSize: 12,
              ),
            ),
            backgroundColor: Colors.white,
            pressElevation: 3,
            elevation: 1,
            onPressed: _openMoreOptions,
          ),
        ],
      ),
    );
  }

  void _openMoreOptions() {
    var route = MaterialPageRoute(
      builder: (context) => MoreFiltersPage(
        selected: searchData.activity,
      ),
    );

    Navigator.of(context).push(route).then((value) {
      if (Checks.isNotNull(value)) {
        widget.onChange!(
          searchData..activity = value,
        );
      } else {
        widget.onChange!(
          searchData..activity = null,
        );
      }
    });
  }
}
