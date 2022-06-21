import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/SelectableChip.dart';
import 'package:rec/Components/Layout/horizontal_list_layout.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Home/Tabs/map/badges_filters_page.dart';
import 'package:rec/Pages/Private/Home/Tabs/map/categories_filters_page.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/app_provider.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
import 'package:rec/extensions/config_settings_app_extension.dart';

// TODO: cleanup this widget

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
    final localizations = AppLocalizations.of(context);
    final campaignProvider = CampaignProvider.of(context);
    final config = AppProvider.of(context).configurationSettings;
    final user = UserState.of(context).user;

    final isInLtabCampaign = user!.getCampaignAccount(env.CMP_LTAB_CODE) != null;
    final ltabCampaign = campaignProvider.getCampaignByCode(env.CMP_LTAB_CODE);
    final cultureCampaign = campaignProvider.getCampaignByCode(env.CMP_CULT_CODE);

    final showLtabFilter = ltabCampaign != null &&
        ltabCampaign.isStarted() &&
        !ltabCampaign.isFinished() &&
        isInLtabCampaign;

    final showCultureFilter =
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
              searchData.activity == null ? 'CATEGORIES' : 'CATEGORIES_FILTERS',
              params: {
                'selected': searchData.activity == null
                    ? ''
                    : searchData.activity!.getNameForLocale(localizations!.locale),
              },
              style: TextStyle(
                color: searchData.activity != null ? Brand.accentColor : Brand.grayDark2,
                fontSize: 12,
              ),
            ),
            backgroundColor: Colors.white,
            pressElevation: 3,
            elevation: 1,
            onPressed: _openCategoriesFilterPage,
          ),
          if (config?.badgeFiltersEnabled == true)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ActionChip(
                label: LocalizedText(
                  searchData.badge == null ? 'BADGES' : 'BADGES_FILTERS',
                  params: {
                    'selected': searchData.badge == null
                        ? ''
                        : searchData.badge!.getNameForLocale(localizations!.locale),
                  },
                  style: TextStyle(
                    color: searchData.badge != null ? Brand.accentColor : Brand.grayDark2,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: Colors.white,
                pressElevation: 3,
                elevation: 1,
                onPressed: _openBadgesFilterPage,
              ),
            ),
        ],
      ),
    );
  }

  void _openCategoriesFilterPage() {
    final route = MaterialPageRoute(
      builder: (context) => CategoriesFiltersPage(
        selected: searchData.activity,
      ),
    );

    Navigator.of(context).push(route).then((newActivity) {
      // If the activity has not changed, not need to emit change
      if (newActivity == searchData.activity) return;

      if (Checks.isNotNull(newActivity)) {
        widget.onChange!(
          searchData..activity = newActivity,
        );
      } else {
        widget.onChange!(
          searchData..activity = null,
        );
      }
    });
  }

  void _openBadgesFilterPage() {
    final route = MaterialPageRoute(
      builder: (context) => BadgesFiltersPage(
        selected: searchData.badge,
      ),
    );

    Navigator.of(context).push(route).then((newBadge) {
      // If the badge has not changed, not need to emit change
      if (newBadge == searchData.badge) return;

      if (Checks.isNotNull(newBadge)) {
        widget.onChange!(
          searchData..badge = newBadge,
        );
      } else {
        widget.onChange!(
          searchData..badge = null,
        );
      }
    });
  }
}
