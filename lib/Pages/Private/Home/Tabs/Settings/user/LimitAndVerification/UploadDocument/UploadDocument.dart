import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rec/Api/Services/UsersService.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';

class UploadDocument extends StatefulWidget {
  final String title;

  UploadDocument({
    this.title,
  });

  @override
  _UploadDocumentState createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {
  final picker = ImagePicker();

  var imageFilePath;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: EmptyAppBar(context, title: widget.title),
        body: SingleChildScrollView(
          child: Padding(
            padding: Paddings.pageNoTop,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                ),
                Text(
                  localizations.translate('SURE_IMAGE_READ'),
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: Brand.detailsTextColor),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 180,
                  color: Brand.defaultAvatarBackground,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 58.0),
                          child: Center(
                            child: IconButton(
                              icon: Icon(Icons.photo_camera),
                              iconSize: 28,
                              onPressed: () {
                                _showSelectionDialog(context);
                              },
                              color: Brand.grayLight2,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 27.33),
                        child: Text(
                          localizations.translate('TOUCH_TO_UP_IMAGE'),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Brand.grayDark4),
                        ),
                      )
                    ],
                  ),
                ),
                RecActionButton(
                  label: localizations.translate('SEND_LEGGIBLE_IMAGE'),
                  backgroundColor: Brand.primaryColor,
                  onPressed: () => SendImage(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('From where do you want to take the photo?'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        _openGallery(context);
                      },
                      child: Text('Gallery'),
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      onTap: () async {
                        _openCamera(context);
                      },
                      child: Text('Camera'),
                    )
                  ],
                ),
              ));
        });
  }

  void _openGallery(BuildContext context) async {
    print('Im in openGallery');
    var picture = await picker.getImage(source: ImageSource.gallery);

    imageFilePath = picture.path;
    print(picture.path);

    Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context) async {
    // var picture = await picker.getImage(source: ImageSource.camera);
    // setState(() async {
    //   // var newImage = (await picture.copy('assets/imageDNI.png').then((value) {
    //   //   print('Saving imageeeeeee');
    //   // }).onError((error, stackTrace) {
    //   //   print('Im in on erroooooooooor');
    //   //   print(error);
    //   // }));
    // });
    // Navigator.of(context).pop();
  }

  void SendImage() {
    var userService = UsersService();

    userService.getImageURL(imageFilePath).then((value) {
      print('Im in then');
      print(value);
    }).onError((error, stackTrace) {
      print('Im in on error');
      print(error);
    });
  }
}
