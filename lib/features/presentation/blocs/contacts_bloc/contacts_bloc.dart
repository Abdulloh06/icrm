/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:icrm/core/models/contacts_model.dart';
import 'package:icrm/core/service/api/get_contacts.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/features/presentation/blocs/contacts_bloc/contacts_event.dart';
import 'package:icrm/features/presentation/blocs/contacts_bloc/contacts_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc(ContactsState initialState) : super(initialState) {
    on<ContactsInitEvent>((event, emit) => _init(event: event, emit: emit));
    on<ContactsAddEvent>((event, emit) => _addContact(event: event, emit: emit));
    on<ContactsUpdateEvent>((event, emit) => _updateContact(event: event, emit: emit));
    on<ContactsDeleteEvent>((event, emit) => _deleteContact(event: event, emit: emit));

    on<ContactsAddFromProject>((event, emit) async {
      final contact_id = await getIt.get<GetContacts>().addContactFromProject(
          name: event.name,
          position: event.position,
          phone_number: event.phone_number,
          email: event.email,
          type: 2,
          source: event.source,
        );

        try {
          int result = int.parse(contact_id.toString());
          emit(ContactsAddFromProjectState(
            id: result,
            name: event.name,
          ));
        }catch(_) {
          emit(ContactsErrorState(error: contact_id));
        }

    });
  }

  Future<void> _init({
    required ContactsInitEvent event,
    required Emitter<ContactsState> emit,
  }) async {
    try {
      final List<ContactModel> contacts =
      await getIt.get<GetContacts>().getContacts();
      emit(ContactsInitState(contacts: contacts));
    } catch (e) {
      print(e);
      emit(ContactsErrorState(error: e.toString()));
    }
  }

  Future<void> _addContact({
    required ContactsAddEvent event,
    required Emitter<ContactsState> emit,
  }) async {
    emit(ContactsLoadingState());

    try {
      String result = await getIt.get<GetContacts>().addContact(
        name: event.name,
        type: event.type,
        position: event.position,
        phone_number: event.phone_number,
        email: event.email,
        avatar: event.avatar,
      );

      if (result == '') {
        emit(ContactsAddState());
      } else {
        emit(ContactsErrorState(error: result));
      }
    } catch (error) {
      print(error);
      emit(ContactsErrorState(error: 'something_went_wrong'));
    }
  }

  Future<void> _updateContact({
    required ContactsUpdateEvent event,
    required Emitter<ContactsState> emit,
  }) async {
    emit(ContactsLoadingState());

    try {
      bool result = await getIt.get<GetContacts>().updateContact(
        id: event.id,
        name: event.name,
        position: event.position,
        phone_number: event.phone_number,
        email: event.email,
        type: event.type,
        avatar: event.avatar,
      );

      if(result) {
        final List<ContactModel> contacts = await getIt.get<GetContacts>().getContacts();
        emit(ContactsInitState(contacts: contacts));
      }else {
        emit(ContactsErrorState(error: 'something_went_wrong'));
      }

    } catch (error) {
      print(error);

      emit(ContactsErrorState(error: error.toString()));
    }
  }

  Future<void> _deleteContact({
    required ContactsDeleteEvent event,
    required Emitter<ContactsState> emit,
  }) async {
    try {
      bool result =
      await getIt.get<GetContacts>().deleteContact(id: event.id);

      if (result) {
        final List<ContactModel> contacts =
        await getIt.get<GetContacts>().getContacts();
        emit(ContactsInitState(contacts: contacts));
      } else {
        emit(ContactsErrorState(error: "something_went_wrong"));
      }
    } catch (e) {
      print(e);
      emit(ContactsErrorState(error: e.toString()));
    }
  }

}
