import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rec/Components/Text/ReadMoreText.dart';
import 'package:rec/Components/Inputs/RecFilterButton.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/Forms/PaymentData.dart';
import 'package:rec/Entities/Transactions/VendorData.ent.dart';
import 'package:rec/Helpers/BrowserHelper.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/PayAddress.page.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/brand.dart';

class ResumeTab extends StatefulWidget {
  final Account account;

  ResumeTab(this.account, {Key key}) : super(key: key);

  @override
  _ResumeTabState createState() => _ResumeTabState();
}

class _ResumeTabState extends State<ResumeTab> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var filterButtons = <RecFilterButton>[
      RecFilterButton(
        icon: Icons.call_made,
        label: 'PAY',
        margin: EdgeInsets.only(right: 8),
        onPressed: _payTo,
        backgroundColor: Brand.primaryColor,
        textColor: Colors.white,
        iconColor: Colors.white,
      ),
      RecFilterButton(
        icon: Icons.assistant_direction,
        label: 'HOW_TO_GO',
        margin: EdgeInsets.only(right: 8),
        onPressed: _launchMapsUrl,
        backgroundColor: Colors.white,
      ),
      RecFilterButton(
        icon: Icons.phone,
        label: 'CALL',
        margin: EdgeInsets.only(right: 8),
        onPressed: _call,
        backgroundColor: Colors.white,
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: filterButtons,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      LocalizedText(
                        widget.account.schedule
                            .getStateNameForDate(DateTime.now()),
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                if (widget.account.description.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ReadMoreText(
                      data: ('"${widget.account.description.trim()}"'),
                      trimCollapsedText: localizations.translate('SHOW_MORE'),
                      trimExpandedText: localizations.translate('SHOW_LESS'),
                    ),
                  ),
                if (widget.account.hasWeb()) SizedBox(height: 16),
                if (widget.account.hasWeb())
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyles.link,
                        text: widget.account.webUrl ?? '',
                        recognizer: TapGestureRecognizer()..onTap = _launchWeb,
                      ),
                    ),
                  ),
                SizedBox(height: 16),
                if (widget.account.hasPublicImage())
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Brand.defaultAvatarBackground,
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            widget.account.publicImage ??
                                'https://picsum.photos/250?image=9',
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _launchWeb() async {
    await BrowserHelper.openBrowser(widget.account.webUrl);
  }

  void _launchMapsUrl() async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${widget.account.latitude},${widget.account.longitude}';
    await BrowserHelper.openBrowser(url);
  }

  void _call() async {
    await BrowserHelper.openCallPhone(widget.account.fullPhone);
  }

  void _payTo() {
    var localizations = AppLocalizations.of(context);
    var paymentData = PaymentData(
      address: widget.account.recAddress,
      amount: null,
      concept: localizations.translate(
        'PAY_TO_NAME',
        params: {
          'name': widget.account.name,
        },
      ),
      vendor: VendorData(name: widget.account.name),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) {
          return PayAddress(
            paymentData: paymentData,
          );
        },
      ),
    );
  }
}
