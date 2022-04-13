import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ContactsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContactsInitEvent extends ContactsEvent {}

class ContactsAddEvent extends ContactsEvent {
  final String name;
  final String position;
  final String email;
  final String phone_number;
  final int type;
  final File avatar;

  ContactsAddEvent({
    required this.email,
    required this.phone_number,
    required this.position,
    required this.name,
    required this.type,
    required this.avatar,
  });

  @override
  List<Object?> get props => [email, position, phone_number, name];
}

class ContactsAddFromProject extends ContactsEvent {
  final String name;
  final String position;
  final String email;
  final String phone_number;
  final int type;
  final int source;

  ContactsAddFromProject({
    required this.email,
    required this.phone_number,
    required this.position,
    required this.name,
    required this.type,
    required this.source,
  });

  @override
  List<Object?> get props => [email, position, phone_number, name, source];
}

class ContactsDeleteEvent extends ContactsEvent {
  final String id;

  ContactsDeleteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class ContactsUpdateEvent extends ContactsEvent {
  final int id;
  final String name;
  final String position;
  final String email;
  final String phone_number;
  final File? avatar;
  final int type;
  final bool hasAvatar;
  final bool fromContact;

  ContactsUpdateEvent({
    required this.id,
    required this.email,
    required this.phone_number,
    required this.position,
    required this.name,
    this.avatar,
    required this.type,
    this.hasAvatar = true,
    this.fromContact = false,
  });

  @override
  List<Object?> get props => [email, position, phone_number, name];
}

class ContactsShowEvent extends ContactsEvent {
  final int id;

  ContactsShowEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
