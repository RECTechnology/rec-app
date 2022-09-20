import 'package:flutter/material.dart';
import 'package:rec/Components/ContainerWithImage.dart';
import 'package:rec/Components/Inputs/PickImage.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';

class OfferImagePicker extends StatelessWidget {
  final String? imageUrl;
  final ValueChanged<String>? onPicked;

  const OfferImagePicker({
    Key? key,
    this.imageUrl,
    this.onPicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
   
    return PickImage(
      onPick: onPicked,
      title: 'OFFER_IMAGE',
      buttonLabel: 'UPDATE',
      hint: 'OFFER_IMAGE_DESC',
      child: AspectRatio(
        aspectRatio: 2.6 / 1,
        child: Stack(
          children: [
            ContainerWithImage(
              image: imageUrl,
            ),
            Container(
              constraints: BoxConstraints.expand(),
              color: Colors.white.withAlpha(90),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      color: recTheme!.grayDark,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: LocalizedText(
                        'PICK_IMAGE',
                        style: TextStyle(
                          color: recTheme.grayDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
