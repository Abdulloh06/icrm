import 'package:icrm/core/models/leads_model.dart';
import 'package:icrm/core/models/projects_model.dart';
import 'package:icrm/core/models/tasks_model.dart';
import 'package:equatable/equatable.dart';

abstract class ArchiveState extends Equatable {}

class ArchiveInitState extends ArchiveState {

  final List<ProjectsModel> projects;
  final List<LeadsModel> leads;
  final List<TasksModel> tasks;

  ArchiveInitState({
    required this.tasks,
    required this.leads,
    required this.projects,
  });

  @override
  List<Object?> get props => [projects, tasks, leads];
}

class ArchiveLoadingState extends ArchiveState {
  @override
  List<Object?> get props => [];
}

class ArchiveErrorState extends ArchiveState {
  final String error;

  ArchiveErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

