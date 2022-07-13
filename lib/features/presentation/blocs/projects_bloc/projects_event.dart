/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:equatable/equatable.dart';
import '../../../../core/models/projects_model.dart';

abstract class ProjectsEvent extends Equatable {}

class ProjectsInitEvent extends ProjectsEvent {
  @override
  List<Object?> get props => [];
}

class ProjectsNextPageEvent extends ProjectsEvent {
  static int page = 1;
  final List<ProjectsModel> list;
  static bool hasReachedMax = false;

  ProjectsNextPageEvent({required this.list});

  @override
  List<Object?> get props => [page];
}

class ProjectsAddEvent extends ProjectsEvent {
  final String name;
  final String? description;
  final int? user_category_id;
  final int project_status_id;
  final bool is_owner;
  final String? notify_at;
  final dynamic price;
  final String? currency;
  final int? company_id;
  final List<int>? members;

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
    required this.members,
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
    members,
  ];
}

class ProjectsUpdateEvent extends ProjectsEvent {
  final int id;
  final String name;
  final String description;
  final int? company_id;
  final int? user_category_id;
  final int project_status_id;
  final List<int>? users;

  ProjectsUpdateEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.project_status_id,
    this.user_category_id,
    this.company_id,
    required this.users,
  });

  @override
  List<Object?> get props => [];
}

class ProjectsDeleteEvent extends ProjectsEvent {
  final int id;

  ProjectsDeleteEvent({required this.id});
  @override
  List<Object?> get props => [id];
}


