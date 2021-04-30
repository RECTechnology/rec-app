import 'package:contacts_service/contacts_service.dart';

class ContactHelper {
  static Future<Iterable<Contact>> getAllContacts(query) async {
    return await ContactsService.getContacts(
      query: query,
      withThumbnails: false,
      photoHighResolution: false,
    );
  }
}
