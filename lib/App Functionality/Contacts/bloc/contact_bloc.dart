import 'package:chat_app_bloc/App%20Functionality/Contacts/bloc/contact_event.dart';
import 'package:chat_app_bloc/App%20Functionality/Contacts/bloc/contact_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc() : super(ContactInitial()) {
    on<LoadContacts>(_onLoadContacts);
  }

  Future<void> _onLoadContacts(
      LoadContacts event, Emitter<ContactState> emit) async {
    emit(ContactLoading());
    try {
      var status = await Permission.contacts.status;

      if (status.isGranted) {
        List<Contact> contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
          deduplicateProperties: false,
        );
        debugPrint("=>Contacts Loaded : ${contacts.length}");
        emit(ContactLoaded(contacts));
      } else {
        debugPrint("=> Permission Denied, can not access contacts.");
        emit(ContactError("Permission Denied, can not access contacts."));
      }
    } catch (e) {
      debugPrint("=> failed to load contacts : ${e.toString()}");

      emit(ContactError("Failed to load Contacts : ${e.toString()}"));
    }
  }
}
