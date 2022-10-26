import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec/styles/paddings.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class UploadDocument extends StatefulWidget {
  final Document? document;
  final String? title;
  final String? buttonLabel;
  final String? hint;

  UploadDocument({
    this.document,
    this.title,
    this.buttonLabel,
    this.hint,
  });

  @override
  _UploadDocumentState createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {
  final picker = ImagePicker();
  final ImageUploaderService _imageUploader = ImageUploaderService(env: env);

  String? imageFilePath;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final recTheme = RecTheme.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: EmptyAppBar(
          context,
          title: widget.document != null ? widget.document!.kind!.name : widget.title,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: Paddings.pageNoTop,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                ),
                LocalizedText(
                  widget.hint ?? 'SURE_IMAGE_READ',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    color: recTheme!.grayDark,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: _openGallery,
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: recTheme.defaultAvatarBackground,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      border: Border.all(
                        color: recTheme.defaultAvatarBackground,
                        width: 3,
                      ),
                    ),
                    child: Checks.isNotEmpty(imageFilePath)
                        ? Image.file(
                            File(imageFilePath!),
                            fit: BoxFit.fitHeight,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.photo_library,
                                  color: recTheme.grayDark3,
                                ),
                              ),
                              const SizedBox(height: 24),
                              LocalizedText(
                                'TOUCH_TO_UP_IMAGE',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: recTheme.grayDark3,
                                ),
                              )
                            ],
                          ),
                  ),
                ),
                RecActionButton(
                  label: widget.buttonLabel ?? localizations!.translate('SEND_LEGGIBLE_IMAGE'),
                  backgroundColor: Checks.isNotEmpty(imageFilePath) ? recTheme.primaryColor : null,
                  onPressed: Checks.isNotEmpty(imageFilePath) ? () => _uploadImage() : null,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openGallery() async {
    var picture = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 20,
      maxHeight: 1000,
    );
    setState(() {
      imageFilePath = picture!.path;
    });
  }

  void _uploadImage() {
    Loading.showCustom(
      content: LocalizedText('UPLOADING_IMAGE_PLEASE_WAIT'),
    );

    _imageUploader.uploadImage(imageFilePath).then((value) {
      Loading.dismiss();
      Navigator.pop(context, value['data']['src']);
    }).catchError((error, stackTrace) {
      Loading.dismiss();
      RecToast.showError(context, 'ERROR_UPLOADING_FILE');
    });
  }
}
