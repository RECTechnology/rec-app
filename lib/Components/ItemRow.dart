import 'package:flutter/material.dart';

class ItemRowRec extends StatefulWidget {
  final List<Widget> children;
  final Alignment aligment;

  ItemRowRec({this.children, this.aligment});

  @override
  State<StatefulWidget> createState() => _ItemRowRecState();
}

class _ItemRowRecState extends State<ItemRowRec> {
  @override
  Widget build(BuildContext context) {
    var itemRow = Container(
      alignment: widget.aligment,
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.children.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: widget.children[index],
                );
              },
            ),
          ),
        ],
      ),
    );
    return itemRow;
  }
}
