import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/styles/box_decorations.dart';

class MapLegendItem {
  final String assetPath;
  final String itemName;

  MapLegendItem({required this.assetPath, required this.itemName});
}

class MapLegendDia extends StatelessWidget {
  static open(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecorations.transparentBorder(),
          // height: MediaQuery.of(context).size.height * 0.4,
          child: MapLegendDia(),
        ),
      ),
    );
  }

  static List<MapLegendItem> getLegendItems(BuildContext context) {
    final theme = RecTheme.of(context);

    return [
      MapLegendItem(assetPath: theme!.assets.markerOffersLegend, itemName: 'MARKER_OFFERS'),
      MapLegendItem(assetPath: theme.assets.markerCulturaLegend, itemName: 'MARKER_CULTURE'),
      MapLegendItem(assetPath: theme.assets.markerNormal, itemName: 'MARKER_NORMAL'),
      MapLegendItem(assetPath: theme.assets.markerComercVerdLegend, itemName: 'MARKER_COMERC_VERD'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = getLegendItems(context);
    final itemWidgets = <Widget>[];
    for (var item in items) {
      itemWidgets.add(
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          // height: 48,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(item.assetPath),
                width: 48,
                height: 48,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: LocalizedText(
                  item.itemName,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 32, top: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LocalizedText(
                'MAP_LEGEND',
                style: Theme.of(context).textTheme.headline6?.copyWith(fontSize: 18),
                uppercase: true,
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          SizedBox(height: 8),
          LocalizedText('MAP_LEGEND_DESC',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
          SizedBox(height: 16),
          Wrap(
            runAlignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: itemWidgets,
          ),
        ],
      ),
    );
  }
}
