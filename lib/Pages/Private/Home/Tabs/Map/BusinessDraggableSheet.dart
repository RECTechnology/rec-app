import 'package:flutter/material.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/DetailsPage/Details.page.dart';
import 'package:rec/Styles/BoxDecorations.dart';
import 'package:rec/brand.dart';

/// Renders a DraggableScrollableSheet for a specified [Account]
/// TODO: Refactor this a bit
class BusinessDraggableSheet extends StatefulWidget {
  final Account business;

  BusinessDraggableSheet({
    Key key,
    @required this.business,
  }) : super(key: key);

  @override
  _BusinessDraggableSheetState createState() => _BusinessDraggableSheetState();
}

class _BusinessDraggableSheetState extends State<BusinessDraggableSheet> {
  List<Widget> bottomSheetList = [];

  @override
  Widget build(BuildContext context) {
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
                  child: DetailsPage(widget.business),
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
}
