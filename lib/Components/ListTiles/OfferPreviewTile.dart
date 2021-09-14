import 'package:flutter/material.dart';
import 'package:rec/Components/ContainerWithImage.dart';
import 'package:rec/Components/Info/OfferPriceBadge.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Text/OfferDiscount.dart';
import 'package:rec/Entities/Offer.ent.dart';
import 'package:rec/brand.dart';

class OfferPreviewTile extends StatelessWidget {
  final Offer offer;
  final VoidCallback onDelete;

  const OfferPreviewTile({
    Key key,
    this.offer,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (c) {
            return OfferActionsModal(
              onAction: (action) {
                switch (action) {
                  case OfferAction.delete:
                    if (onDelete != null) onDelete();
                }
              },
            );
          },
        );
      },
      borderRadius: BorderRadius.all(Radius.circular(6)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 2.6 / 1,
                  child: ContainerWithImage(
                    image: offer.image,
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 0,
                  child: OfferBadge(offer: offer),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer.description,
                            style: textTheme.subtitle1.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '5 may 2021',
                                style: textTheme.bodyText2.copyWith(
                                  color: Brand.grayDark3,
                                ),
                              ),
                              Icon(
                                Icons.hourglass_top,
                                size: 16,
                                color: Brand.grayDark3,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (offer.hasDiscount) OfferDiscount(offer: offer),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum OfferAction {
  delete,
}

class OfferActionsModal extends StatefulWidget {
  final ValueChanged<OfferAction> onAction;
  OfferActionsModal({Key key, this.onAction}) : super(key: key);

  @override
  _OfferActionsModalState createState() => _OfferActionsModalState();
}

class _OfferActionsModalState extends State<OfferActionsModal> {
  void _deleteOffer() {
    Navigator.of(context).pop();
    if (widget.onAction != null) widget.onAction(OfferAction.delete);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LocalizedText('WHAT_TO_DO_WITH_OFFER'),
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: LocalizedText('DELETE'),
            onTap: _deleteOffer,
          ),
        ],
      ),
    );
  }
}
