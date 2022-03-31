import 'package:avlo/core/models/contacts_model.dart';
import 'package:avlo/core/service/api/get_contacts.dart';
import 'package:avlo/core/util/get_it.dart';
import 'package:avlo/features/presentation/blocs/contacts_bloc/contacts_event.dart';
import 'package:avlo/features/presentation/blocs/contacts_bloc/contacts_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc(ContactsState initialState) : super(initialState) {
    on<ContactsInitEvent>((event, emit) async {
      try {
        final List<ContactModel> contacts =
            await getIt.get<GetContacts>().getContacts();
        emit(ContactsInitState(contacts: contacts));
      } catch (e) {
        print(e);
        emit(ContactsErrorState(error: e.toString()));
      }
    });

    on<ContactsAddEvent>((event, emit) async {
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
          final List<ContactModel> contacts =
              await getIt.get<GetContacts>().getContacts();
          emit(ContactsInitState(contacts: contacts));
        } else {
          emit(ContactsErrorState(error: result));
        }
      } catch (error) {
        print(error);
        emit(ContactsErrorState(error: 'something_went_wrong'));
      }
    });

    on<ContactsUpdateEvent>((event, emit) async {
      emit(ContactsLoadingState());

      try {
        ContactModel contact = await getIt.get<GetContacts>().updateContact(
          id: event.id,
          name: event.name,
          position: event.position,
          phone_number: event.phone_number,
          email: event.email,
          type: event.type,
          avatar: event.avatar,
          hasAvatar: event.hasAvatar,
        );
        emit(ContactsShowState(contact: contact));
      } catch (error) {
        print(error);

        emit(ContactsErrorState(error: error.toString()));
      }
    });

    on<ContactsDeleteEvent>((event, emit) async {
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
    });

    on<ContactsShowEvent>((event, emit) async {
      emit(ContactsLoadingState());

      try {
        ContactModel contact =
            await getIt.get<GetContacts>().showContact(id: event.id);

        emit(ContactsShowState(contact: contact));
      } catch (error) {
        print(error);
        emit(ContactsErrorState(error: error.toString()));
      }
    });

    on<ContactsAddFromProject>((event, emit) async {
      try {
        int contact_id = await getIt.get<GetContacts>().addContactFromProject(
          name: event.name,
          position: event.position,
          phone_number: event.phone_number,
          email: event.email,
          type: 2,
          source: event.source,
        );

        emit(ContactsAddFromProjectState(
          id: contact_id,
          name: event.name,
        ));
      } catch (error) {
        print(error);
        emit(ContactsErrorState(error: error.toString()));
      }
    });
  }
}
