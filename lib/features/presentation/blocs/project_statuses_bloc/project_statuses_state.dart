/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/status_model.dart';
import 'package:equatable/equatable.dart';

class ProjectStatusState extends Equatable{
  @override
  List<Object?> get props => [];
}

class ProjectStatusInitState extends ProjectStatusState {
  final List<StatusModel> projectStatuses;

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
