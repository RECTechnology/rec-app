import 'package:flutter/material.dart';
import 'package:rec/Components/ContainerWithImage.dart';
import 'package:rec/Components/Info/OfferPriceBadge.dart';
import 'package:rec/Components/Text/OfferDiscount.dart';
import 'package:rec/Entities/Offer.ent.dart';
import 'package:rec/brand.dart';

class OfferPreviewTile extends StatelessWidget {
  final Offer offer;

  const OfferPreviewTile({Key key, this.offer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {},
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
