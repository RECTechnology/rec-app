import 'package:contacts_service/contacts_service.dart';

class Contacts {
  /// It fetches the contacts in the User's phone, using [ContactsService]
  static Future<Iterable<Contact>> getAllContacts(
    String query,
  ) async {
    return await ContactsService.getContacts(
      query: query,
      withThumbnails: false,
      photoHighResolution: false,
    );
  }
}
