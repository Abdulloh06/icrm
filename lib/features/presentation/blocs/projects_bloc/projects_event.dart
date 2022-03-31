import 'package:avlo/features/presentation/pages/main/main_page_includes.dart';
import 'package:equatable/equatable.dart';

abstract class ProjectsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProjectsInitEvent extends ProjectsEvent {}

class ProjectsAddEvent extends ProjectsEvent {
  final String name;
  final String description;
  final int user_category_id;
  final int project_status_id;
  final bool is_owner;
  final String notify_at;
  final dynamic price;
  final String currency;
  final int company_id;

  ProjectsAddEvent({
    required this.name,
    required this.description,
    required this.user_category_id,
    required this.project_status_id,
    required this.notify_at,
    required this.currency,
    required this.is_owner,
    required this.price,
    required this.company_id,
  });

  @override
  List<Object?> get props => [
    name,
    description,
    currency,
    price,
    notify_at,
    is_owner,
    user_category_id,
    project_status_id,
    company_id,
  ];
}

class ProjectsUpdateEvent extends ProjectsEvent {
  final int id;
  final String name;
  final String description;
  final int company_id;
  final int user_category_id;
  final int project_status_id;

  ProjectsUpdateEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.project_status_id,
    required this.user_category_id,
    required this.company_id,
  });
}

class ProjectsCompanyEvent extends ProjectsEvent {
  final int company_id;
  final String name;

  ProjectsCompanyEvent({
    required this.company_id,
    required this.name,
  });

  @override
  List<Object?> get props => [company_id, name];
}

class ProjectsNameEvent extends ProjectsEvent {
  final int contact_id;
  final String name;

  ProjectsNameEvent({
    required this.contact_id,
    required this.name,
  });

  @override
  List<Object?> get props => [contact_id, name];
}

class ProjectsShowEvent extends ProjectsEvent {
  final int id;

  ProjectsShowEvent({required this.id});
}

class ProjectsUserCategoryEvent extends ProjectsEvent {
  final int id;
  final String name;

  ProjectsUserCategoryEvent({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class ProjectsAddStatusEvent extends ProjectsEvent {
  final int id;
  final String name;

  ProjectsAddStatusEvent({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class ProjectsDeleteEvent extends ProjectsEvent {
  final int id;

  ProjectsDeleteEvent({required this.id});
}


