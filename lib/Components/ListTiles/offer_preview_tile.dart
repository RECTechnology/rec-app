import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rec/Components/ContainerWithImage.dart';
import 'package:rec/Components/Info/OfferPriceBadge.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Text/OfferDiscount.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class OfferPreviewTile extends StatelessWidget {
  final Offer? offer;
  final VoidCallback? onDelete;
  final bool hasActions;

  const OfferPreviewTile({
    Key? key,
    this.offer,
    this.onDelete,
    this.hasActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final recTheme = RecTheme.of(context);
    final localizations = AppLocalizations.of(context);

    final date = DateFormat.yMMMd(localizations!.locale.languageCode)
        .format(DateTime.tryParse(offer!.endDate!)!);

    return InkWell(
      onTap: hasActions
          ? () {
              showModalBottomSheet(
                context: context,
                builder: (c) {
                  return OfferActionsModal(
                    onAction: (action) {
                      switch (action) {
                        case OfferAction.delete:
                          if (onDelete != null) onDelete!();
                      }
                    },
                  );
                },
              );
            }
          : null,
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
                    image: offer!.image,
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
                            offer!.description ?? 'NO_DESCRIPTION',
                            style: textTheme.subtitle1!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                date,
                                style: textTheme.bodyText2!.copyWith(
                                  color: recTheme!.grayDark3,
                                ),
                              ),
                              Icon(
                                Icons.hourglass_top,
                                size: 16,
                                color: recTheme.grayDark3,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (offer!.hasDiscount && !offer!.isFree) OfferDiscount(offer: offer),
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
  final ValueChanged<OfferAction>? onAction;
  OfferActionsModal({Key? key, this.onAction}) : super(key: key);

  @override
  _OfferActionsModalState createState() => _OfferActionsModalState();
}

class _OfferActionsModalState extends State<OfferActionsModal> {
  void _deleteOffer() {
    Navigator.of(context).pop();
    if (widget.onAction != null) widget.onAction!(OfferAction.delete);
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
