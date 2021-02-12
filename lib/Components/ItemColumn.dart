import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemColumn extends StatefulWidget{
  final List<Widget>children;
  final Alignment aligment;

  ItemColumn({
    this.children,
    this.aligment
  });

  @override
  State<StatefulWidget> createState() => new _ItemColumnState();
}

class _ItemColumnState extends State<ItemColumn>{
  @override
  Widget build(BuildContext context) {
    Container itemColumn = Container(
      alignment: widget.aligment,
      child: Column(
        children: <Widget>[
          Expanded(child:ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget.children.length,
            itemBuilder: (context,index){
              return ListTile(
                title: widget.children[index],
              );
            },
          ) )

        ],
      ),
    );
    return itemColumn;

  }

}