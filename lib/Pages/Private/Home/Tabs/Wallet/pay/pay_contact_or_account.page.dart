import 'package:flutter/material.dart';
import 'package:rec/Components/Lists/AccountList.dart';
import 'package:rec/Components/Lists/ContactsList.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/pay_to_address.page.dart';
import 'package:rec/Components/IfPermissionGranted.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/config/features.dart';
import 'package:rec/permissions/permission_data_provider.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class PayContactOrAccount extends StatefulWidget {
  @override
  _PayContactOrAccountState createState() => _PayContactOrAccountState();
}

class _PayContactOrAccountState extends State<PayContactOrAccount> with TickerProviderStateMixin {
  TabController? _tabController;
  int items = 2;
  final PaymentData _paymentData = PaymentData.empty();
  int initialIndex = 0;

  @override
  void initState() {
    // NOTE: Disable contact list
    if (!Features.contactList) {
      items = 1;
    }
    _tabController = TabController(
      length: items,
      vsync: this,
      initialIndex: initialIndex,
    );
    _tabController!.addListener(() {
      setState(() {
        initialIndex = _tabController!.index;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _content();
  }

  Widget _content() {
    final recTheme = RecTheme.of(context);
    final body = _tabController == null
        ? SizedBox()
        : TabBarView(
            controller: _tabController,
            children: <Widget>[
              // Only show contact list tab if feature is enabled
              if (Features.contactList)
                IfPermissionGranted(
                  permission: PermissionDataProvider.contacts,
                  canBeDeclined: false,
                  builder: (_) => ContactsList(
                    onPick: _pickedContact,
                  ),
                  onDecline: () {
                    print('permission declined');
                  },
                ),
              AccountList(
                onPick: _pickedAccount,
              ),
            ],
          );

    return Scaffold(
      appBar: _constructAppBar(),
      backgroundColor: recTheme!.defaultAvatarBackground,
      body: body,
    );
  }

  void _pickedAccount(Account account) {
    _paymentData.vendor!.name = account.name;
    _paymentData.vendor!.image = account.publicImage;
    _paymentData.vendor!.type = account.type;
    _paymentData.address = account.recAddress;
    _navigateToPayAddress(_paymentData);
  }

  void _pickedContact(ContactInfo contact) {
    _paymentData.vendor!.name = contact.account;
    _paymentData.vendor!.image = contact.image;
    _paymentData.address = contact.address;
    _navigateToPayAddress(_paymentData);
  }

  void _navigateToPayAddress(PaymentData data) {
    var localizations = AppLocalizations.of(context);
    _paymentData.concept = localizations!.translate(
      'PAY_TO_NAME',
      params: {
        'name': data.vendor!.name,
      },
    );

    var route = MaterialPageRoute(
      builder: (ctx) => PayAddressPage(paymentData: data),
    );
    Navigator.of(context).push(route).then((value) {
      if (value == true) Navigator.of(context).pop(value);
    });
  }

  AppBar _constructAppBar() {
    double height = Features.contactList ? 120 : 0;
    var contactsButton = _constructButton(
      title: 'CONTACTS',
      action: () {
        if (!_tabController!.indexIsChanging) {
          setState(() => _tabController!.index = 0);
        }
      },
      icon: Icons.import_contacts_outlined,
      active: _tabController != null && _tabController!.index == 0,
    );
    var accountsButton = _constructButton(
      title: 'ACCOUNTS',
      action: () {
        if (!_tabController!.indexIsChanging) {
          setState(() => _tabController!.index = 1);
        }
      },
      icon: Icons.send,
      active: _tabController != null && _tabController!.index == 1,
    );

    return AppBar(
      backgroundColor: Colors.white,
      title: LocalizedText(
        Features.contactList ? 'PAY_TO' : 'PAY_ACCOUNT',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(height),
        child: Container(
          height: height,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: Features.contactList
                ? [
                    contactsButton,
                    accountsButton,
                  ]
                : [],
          ),
        ),
      ),
    );
  }

  Widget _constructButton({
    Function? action,
    required bool active,
    required String title,
    IconData? icon,
  }) {
    final recTheme = RecTheme.of(context);
    final color = (active ? recTheme?.primaryColor : recTheme!.grayDark) ?? Colors.black;

    return SizedBox(
      height: 80,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            // backgroundColor: recTheme!.grayDark,
            side: BorderSide(color: color),
          ),
          onPressed: action as void Function()?,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 24),
                SizedBox(height: 8),
                LocalizedText(
                  title,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        color: color,
                        fontWeight: active ? FontWeight.w500 : FontWeight.w400,
                      ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
