import 'package:avlo/core/models/project_statuses_model.dart';
import 'package:avlo/core/models/projects_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProjectsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProjectsInitState extends ProjectsState {

  final List<ProjectsModel> projects;

  ProjectsInitState({required this.projects});

  @override
  List<Object?> get props => [projects];
}

class ProjectsAddSuccessState extends ProjectsState {
  final ProjectsModel project;

  ProjectsAddSuccessState({required this.project});

  @override
  List<Object?> get props => [project];
}

class ProjectsShowState extends ProjectsState {
  final ProjectsModel project;
  final List<ProjectStatusesModel> projectsStatuses;

  ProjectsShowState({
    required this.project,
    required this.projectsStatuses,
  });
}

class ProjectsNameState extends ProjectsState {
  final int contact_id;
  final String contact_name;

  ProjectsNameState({
    required this.contact_id,
    required this.contact_name,
  });

  @override
  List<Object?> get props => [contact_id, contact_name];
}

class ProjectsCompanyState extends ProjectsState {
  final int company_id;
  final String name;

  ProjectsCompanyState({
    required this.company_id,
    required this.name,
  });

  @override
  List<Object?> get props => [company_id];
}

class ProjectsUserCategoryState extends ProjectsState {
  final int id;
  final String name;

  ProjectsUserCategoryState({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class ProjectsAddStatusState extends ProjectsState {
  final int id;
  final String name;

  ProjectsAddStatusState({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class ProjectsErrorState extends ProjectsState {
  final String error;

  ProjectsErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

class ProjectsLoadingState extends ProjectsState {}

