import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:rec/Api/third-party/Contacts.dart';
import 'package:rec/Components/ListTiles/AccountListTile.dart';
import 'package:rec/Components/Info/rec_circle_avatar.dart';
import 'package:rec/Components/Layout/InfoSplash.dart';
import 'package:rec/Components/Lists/SearchableList.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/config/brand.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ContactsList extends StatefulWidget {
  final RecContactsService? service;
  final Function(ContactInfo contact)? onPick;

  const ContactsList({
    Key? key,
    this.service,
    this.onPick,
  }) : super(key: key);

  @override
  _ContactsList createState() => _ContactsList();
}

class _ContactsList extends State<ContactsList> {
  bool isLoading = true;
  List<Contact> contacts = [];
  List<ContactInfo> recContacts = [];
  List<Widget> searchedWidgets = [];

  String searchQuery = '';
  late RecContactsService service;

  @override
  void initState() {
    service = widget.service ?? RecContactsService(env: env);
    _loadContacts();
    super.initState();
  }

  void _loadContacts() {
    setState(() {
      isLoading = true;
    });

    Contacts.getAllContacts('')
        .then((c) => c.toList())
        .then((c) => _searchInApi(c))
        .then((c) => _mapContacts(c as List<ContactInfo>))
        .then((c) => setState(() => isLoading = false))
        .catchError(_onError);
  }

  @override
  Widget build(BuildContext context) {
    return SearchableList(
      searchHintText: 'SEARCH_CONTACTS',
      noItemsWidget: _noContacts(),
      isLoading: isLoading,
      items: searchedWidgets,
      search: (query) {
        searchQuery = query;
        _mapContacts(recContacts);
      },
    );
  }

  Future<List<dynamic>> _searchInApi(List<Contact> contacts) async {
    var phoneList =
        contacts.where((e) => e.phones!.isNotEmpty).map((e) => e.phones!.first.value).toList();

    var apiContacts = await service.getContacts(phoneList).catchError(_onError);

    // ignore: unnecessary_null_comparison
    return recContacts = apiContacts != null
        ? apiContacts.items!.where((element) => !element.isMyAccount!).toList()
        : [];
  }

  _onError(err) {
    RecToast.showError(context, err.message);
  }

  void _mapContacts(List<ContactInfo> recContacts) {
    setState(
      () => searchedWidgets = recContacts
          .where(_matchesQuery)
          .map(
            (contact) => AccountListTile(
              onTap: () {
                widget.onPick!(contact);
              },
              avatar: CircleAvatarRec(
                name: contact.account,
                imageUrl: contact.image,
              ),
              name: contact.account,
              trailing: Icon(
                Icons.person,
                color: Brand.grayLight2,
                size: 16,
              ),
            ),
          )
          .toList(),
    );
  }

  bool _matchesQuery(ContactInfo contact) {
    return contact.account!.toLowerCase().contains(searchQuery.toLowerCase());
  }

  Widget _noContacts() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: InfoSplash(
        icon: Icons.import_contacts_outlined,
        title: 'NO_CONTACTS',
        subtitle: 'NO_CONTACTS_DESC',
      ),
    );
  }
}
