/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/leads_model.dart';
import 'package:icrm/core/models/status_model.dart';
import 'package:icrm/core/models/projects_model.dart';
import 'package:icrm/core/models/tasks_model.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {}

class SearchInitState extends SearchState {
  final List<LeadsModel> leads;
  final List<ProjectsModel> projects;
  final List<TasksModel> tasks;

  final List<StatusModel> projectStatuses;
  final List<StatusModel> leadStatuses;
  final List<StatusModel> taskStatuses;

  SearchInitState({
    required this.leads,
    required this.tasks,
    required this.projects,
    required this.leadStatuses,
    required this.projectStatuses,
    required this.taskStatuses,
  });

  @override
  List<Object?> get props => [
    leads, projects, tasks,
  ];
}

class SearchProjectsState extends SearchState {

  final List<ProjectsModel> projects;

  SearchProjectsState({required this.projects});

  @override
  List<Object?> get props => [projects];
}

class SearchLoadingState extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchErrorState extends SearchState {
  final String error;

  SearchErrorState({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}