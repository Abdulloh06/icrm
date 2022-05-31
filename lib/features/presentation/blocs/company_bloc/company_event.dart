/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


part of 'company_bloc.dart';

abstract class CompanyEvent extends Equatable {
  const CompanyEvent();

  @override
  List<Object> get props => [];
}

class CompanyInitEvent extends CompanyEvent {}

class CompanyAddEvent extends CompanyEvent {
  final String name;
  final File? image;
  final String? url;
  final int? contactId;
  final String description;

  CompanyAddEvent({
    required this.contactId,
    required this.image, 
    required this.url, 
    required this.name,
    required this.description,
  });
}

class CompanyUpdateEvent extends CompanyEvent {
  final int id;
  final String name;
  final String description;
  final File? logo;
  final String url;
  final int? contact_id;

  CompanyUpdateEvent({
    required this.id,
    required this.logo,
    required this.description,
    required this.name,
    required this.contact_id,
    required this.url,
  });
}

class CompanyDeleteEvent extends CompanyEvent {
  final int id;

  CompanyDeleteEvent({required this.id});
}

class CompanyShowEvent extends CompanyEvent {
  final int id;

  CompanyShowEvent({required this.id});
}

