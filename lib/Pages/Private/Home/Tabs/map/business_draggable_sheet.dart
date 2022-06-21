import 'package:flutter/material.dart';
import 'package:rec/Pages/Private/Home/Tabs/map/details_page/details.page.dart';
import 'package:rec/config/brand.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class BusinessDraggableSheet extends StatelessWidget {
  final Account? business;
  final bool isLoading;

  BusinessDraggableSheet({
    Key? key,
    required this.business,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
    );

    return DraggableScrollableSheet(
      maxChildSize: 0.95,
      minChildSize: 0.25,
      initialChildSize: 0.25,
      builder: (
        BuildContext context,
        ScrollController scrollController,
      ) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                offset: Offset(0, -4),
                blurRadius: 15,
              ),
            ],
            borderRadius: radius,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 56,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 108,
                      child: isLoading
                          ? Padding(
                              padding: const EdgeInsets.only(top: 42.0),
                              child: Column(
                                children: [
                                  CircularProgressIndicator(),
                                ],
                              ),
                            )
                          : DetailsPage(
                              business as Account,
                              scrollController: scrollController,
                            ),
                    ),
                  ),
                ),
                _greyBar()
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _greyBar() {
    return IgnorePointer(
      child: Container(
        height: 25,
        alignment: Alignment.center,
        color: Colors.white,
        child: Container(
          margin: const EdgeInsets.all(8.0),
          width: 60,
          height: 5,
          decoration: BoxDecoration(
            color: Brand.grayLight2,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
    );
  }
}
