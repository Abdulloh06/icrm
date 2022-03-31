import 'package:avlo/core/models/project_statuses_model.dart';
import 'package:equatable/equatable.dart';

class ProjectStatusState extends Equatable{
  @override
  List<Object?> get props => [];
}

class ProjectStatusInitState extends ProjectStatusState {
  final List<ProjectStatusesModel> projectStatuses;

  ProjectStatusInitState({required this.projectStatuses});

  @override
  List<Object?> get props => [projectStatuses];
}

class ProjectStatusLoadingState extends ProjectStatusState {}

class ProjectStatusErrorState extends ProjectStatusState {
  final String error;

  ProjectStatusErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
