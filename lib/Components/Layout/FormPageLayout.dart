import 'package:flutter/material.dart';
import 'package:rec/Styles/Paddings.dart';

class FormPageLayout extends StatefulWidget {
  final PreferredSizeWidget appBar;
  final Widget form;
  final Widget header;
  final Widget submitButton;
  final Widget actionButton;

  FormPageLayout({
    Key key,
    @required this.form,
    @required this.submitButton,
    this.appBar,
    this.actionButton,
    this.header,
  }) : super(key: key);

  @override
  _FormPageLayoutState createState() => _FormPageLayoutState();
}

class _FormPageLayoutState extends State<FormPageLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.appBar,
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.pageNoTop,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.header ?? SizedBox.shrink(),
                  widget.form,
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: widget.submitButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
