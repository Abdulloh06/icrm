
/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:icrm/core/models/projects_model.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/models/status_model.dart';

abstract class ProjectsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProjectsInitState extends ProjectsState {

  final List<ProjectsModel> projects;
  final List<StatusModel> projectStatus;
  static bool hasReachedMax = false;
  ProjectsInitState({
    required this.projects,
    required this.projectStatus,
  });

  @override
  List<Object?> get props => [projects];
}

class ProjectsAddSuccessState extends ProjectsState {
  final ProjectsModel project;

  ProjectsAddSuccessState({required this.project});

  @override
  List<Object?> get props => [project];
}

class ProjectsErrorState extends ProjectsState {
  final String error;

  ProjectsErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

class ProjectsLoadingState extends ProjectsState {}

