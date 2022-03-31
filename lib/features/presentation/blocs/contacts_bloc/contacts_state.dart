import 'package:avlo/core/models/contacts_model.dart';
import 'package:equatable/equatable.dart';

abstract class ContactsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContactsInitState extends ContactsState {
  final List<ContactModel> contacts;

  ContactsInitState({required this.contacts});

  @override
  List<Object?> get props => [contacts];
}

class ContactsShowState extends ContactsState {
  final ContactModel contact;

  ContactsShowState({required this.contact});

  @override
  List<Object?> get props => [contact];
}

class ContactsAddFromProjectState extends ContactsState {
  final int id;
  final String name;

  ContactsAddFromProjectState({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id];
}

class ContactsLoadingState extends ContactsState {}

class ContactsErrorState extends ContactsState {
  final String error;

  ContactsErrorState({required this.error});
}
