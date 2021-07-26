import 'package:flutter/material.dart';
import 'package:rec/Components/Lists/AccountList.dart';
import 'package:rec/Components/Lists/ContactsList.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/ContactInfo.dart';
import 'package:rec/Entities/Forms/PaymentData.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/PayAddress.page.dart';
import 'package:rec/Components/IfPermissionGranted.dart';
import 'package:rec/Permissions/permission_data_provider.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class PayContactOrAccount extends StatefulWidget {
  @override
  _PayContactOrAccountState createState() => _PayContactOrAccountState();
}

class _PayContactOrAccountState extends State<PayContactOrAccount>
    with TickerProviderStateMixin {
  TabController _tabController;
  final int items = 2;
  final PaymentData _paymentData = PaymentData.empty();
  int initialIndex = 0;

  @override
  void initState() {
    _tabController = TabController(
      length: items,
      vsync: this,
      initialIndex: initialIndex,
    );
    _tabController.addListener(() {
      setState(() {
        initialIndex = _tabController.index;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _content();
  }

  Widget _content() {
    var body = _tabController == null
        ? SizedBox()
        : TabBarView(
            controller: _tabController,
            children: <Widget>[
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
      backgroundColor: Brand.defaultAvatarBackground,
      body: body,
    );
  }

  void _pickedAccount(Account account) {
    _paymentData.vendor.name = account.name;
    _paymentData.vendor.image = account.publicImage;
    _paymentData.vendor.type = account.type;
    _paymentData.address = account.recAddress;
    _navigateToPayAddress(_paymentData);
  }

  void _pickedContact(ContactInfo contact) {
    _paymentData.vendor.name = contact.account;
    _paymentData.vendor.image = contact.image;
    _paymentData.address = contact.address;
    _navigateToPayAddress(_paymentData);
  }

  void _navigateToPayAddress(PaymentData data) {
    var localizations = AppLocalizations.of(context);
    _paymentData.concept = localizations.translate(
      'PAY_TO_NAME',
      params: {
        'name': data.vendor.name,
      },
    );

    var route = MaterialPageRoute(
      builder: (ctx) => PayAddress(paymentData: data),
    );
    Navigator.of(context).push(route).then((value) {
      if (value == true) Navigator.of(context).pop(value);
    });
  }

  AppBar _constructAppBar() {
    var localizations = AppLocalizations.of(context);
    var contactsButton = _constructButton(
      title: 'CONTACTS',
      action: () {
        if (!_tabController.indexIsChanging) {
          setState(() => _tabController.index = 0);
        }
      },
      icon: Icons.import_contacts_outlined,
      active: _tabController != null && _tabController.index == 0,
    );
    var accountsButton = _constructButton(
      title: 'ACCOUNTS',
      action: () {
        if (!_tabController.indexIsChanging) {
          setState(() => _tabController.index = 1);
        }
      },
      icon: Icons.send,
      active: _tabController != null && _tabController.index == 1,
    );

    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        localizations.translate('PAY_TO'),
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          height: 120,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [contactsButton, accountsButton],
          ),
        ),
      ),
    );
  }

  Widget _constructButton({
    Function action,
    bool active,
    String title,
    IconData icon,
  }) {
    var localizations = AppLocalizations.of(context);
    var color = active ? Brand.primaryColor : Brand.grayDark;

    return SizedBox(
      height: 80,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            primary: Brand.grayDark,
            side: BorderSide(color: color),
          ),
          onPressed: action,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 24),
                SizedBox(height: 8),
                Text(
                  localizations.translate(title),
                  style: Theme.of(context).textTheme.caption.copyWith(
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
