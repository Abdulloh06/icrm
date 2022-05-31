/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/contacts_model.dart';
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

class ContactsAddState extends ContactsState {}

class ContactsLoadingState extends ContactsState {}

class ContactsErrorState extends ContactsState {
  final String error;

  ContactsErrorState({required this.error});
}
