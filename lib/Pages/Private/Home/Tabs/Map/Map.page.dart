import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Estoy en la pestaña Mapa'),
      ),
    );
  }
}
