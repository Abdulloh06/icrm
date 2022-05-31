/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:icrm/core/models/leads_model.dart';
import 'package:icrm/core/models/projects_model.dart';
import 'package:icrm/core/models/tasks_model.dart';
import 'package:equatable/equatable.dart';

abstract class ArchiveEvent extends Equatable {}

class ArchiveInitEvent extends ArchiveEvent {

  @override
  List<Object?> get props => [];
}

class ArchiveGetNextPageEvent extends ArchiveEvent {
  final List<ProjectsModel> projects;
  final List<LeadsModel> leads;
  final List<TasksModel> tasks;
  final int id;

  ArchiveGetNextPageEvent({
    required this.projects,
    required this.tasks,
    required this.leads,
    required this.id,
  });


  @override
  List<Object?> get props => [];
}