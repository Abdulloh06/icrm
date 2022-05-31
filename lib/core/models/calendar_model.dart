/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/leads_model.dart';
import 'package:icrm/core/models/tasks_model.dart';
import 'package:flutter/foundation.dart';

@immutable
class CalendarModel {

  final List<TasksModel> tasks;
  final List<LeadsModel> leads;

  CalendarModel({
    required this.leads,
    required this.tasks,
  });

  factory CalendarModel.fromJson(Map<String, dynamic> json) {
    return CalendarModel(
      leads: fetchLeads(json['leads'] ?? []),
      tasks: fetchTasks(json['tasks'] ?? []),
    );
  }

  static List<TasksModel> fetchTasks(List data) {
    List<TasksModel> tasks = [];

    for(int i = 0; i < data.length; i++) {
      tasks.add(TasksModel.fromJson(data[i]));
    }
    return tasks;
  }

  static List<LeadsModel> fetchLeads(List data) {
    List<LeadsModel> leads = [];

    for(int i = 0; i < data.length; i++) {
      leads.add(LeadsModel.fromJson(data[i]));
    }
    return leads;
  }


}