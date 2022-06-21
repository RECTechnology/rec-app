import 'package:flutter/material.dart';

mixin Loadable {
  bool isLoading = false;
  void setIsLoading(bool isLoading);
}


mixin StateLoading<T extends StatefulWidget> on State<T> {
  bool isLoading = false;

  setLoading(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  startLoading() => setLoading(true);
  stopLoading() => setLoading(false);
}
