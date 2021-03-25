import 'package:flutter/material.dart';

class ItemColumnRec extends StatefulWidget {
  final List<Widget> children;
  final Alignment aligment;

  ItemColumnRec({this.children, this.aligment});

  @override
  State<StatefulWidget> createState() => _ItemColumnRecState();
}

class _ItemColumnRecState extends State<ItemColumnRec> {
  @override
  Widget build(BuildContext context) {
    var itemColumn = Container(
      alignment: widget.aligment,
      child: Column(
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
          )
        ],
      ),
    );
    return itemColumn;
  }
}
