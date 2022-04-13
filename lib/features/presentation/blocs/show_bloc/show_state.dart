import 'package:icrm/core/models/leads_model.dart';
import 'package:icrm/core/models/leads_status_model.dart';
import 'package:icrm/core/models/project_statuses_model.dart';
import 'package:icrm/core/models/projects_model.dart';
import 'package:icrm/core/models/tasks_model.dart';
import 'package:icrm/core/models/tasks_status_model.dart';
import 'package:equatable/equatable.dart';

abstract class ShowState extends Equatable {}

class ShowLeadState extends ShowState {
  final LeadsModel lead;
  final List<LeadsStatusModel> leadStatus;

  ShowLeadState({
    required this.lead,
    required this.leadStatus,
  });

  @override
  List<Object?> get props => [lead, leadStatus];
}

class ShowProjectState extends ShowState {
  final ProjectsModel project;
  final List<ProjectStatusesModel> projectsStatuses;

  ShowProjectState({
    required this.project,
    required this.projectsStatuses,
  });

  @override
  List<Object?> get props => [project, projectsStatuses];
}

class ShowTaskState extends ShowState {
  final TasksModel task;
  final List<TaskStatusModel> taskStatuses;

  ShowTaskState({
    required this.task,
    required this.taskStatuses,
  });

  @override
  List<Object?> get props => [task];
}

class ShowTaskUpdateState extends ShowState {
  @override
  List<Object?> get props => [];
}

class ShowLoadingState extends ShowState {
  @override
  List<Object?> get props => [];
}

class ShowErrorState extends ShowState {
  final String error;

  ShowErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}