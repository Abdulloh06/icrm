/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/comments_model.dart';
import 'package:icrm/core/models/status_model.dart';
import 'package:icrm/core/models/team_model.dart';
import 'package:flutter/foundation.dart';

@immutable
class TasksModel {
  final int id;
  final dynamic parentId;
  final int taskStatusId;
  final String startDate;
  final String deadline;
  final String name;
  final String description;
  final String taskType;
  final int priority;
  final int taskId;
  final StatusModel? taskStatus;
  final String createdAt;
  final String updatedAt;
  final List<CommentsModel> comments;
  final List<TasksModel>? subtasks;
  final List<TeamModel>? members;

  TasksModel({
    required this.id,
    required this.parentId,
    required this.taskStatusId,
    required this.startDate,
    required this.deadline,
    required this.name,
    required this.description,
    required this.taskType,
    required this.taskId,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    required this.comments,
    this.taskStatus,
    this.subtasks,
    this.members,
  });

  factory TasksModel.fromJson(Map<String, dynamic> json) {

    StatusModel? status;
    if(json['label'] != null) {
      status = StatusModel.fromJson(json['label']);
    }

    return TasksModel(
      id: json['id'],
      parentId: json['parent_id'],
      taskStatusId: json['label_id'],
      startDate: json['start_date'] ?? "",
      deadline: json['deadline'] ?? "",
      priority: json['priority'],
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      taskType: json['taskable_type'] as String,
      taskId: json['taskable_id'] ?? 1,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      comments: CommentsModel.fetchData(json['comments'] ?? []),
      taskStatus: status,
      subtasks: fetchSubtasks(json['children'] ?? []),
      members: fetchMembers(json['assigns'] ?? []),
    );
  }

  static List<TasksModel> fetchData(Map<String, dynamic> data) {
    List items = data['data'];
    List<TasksModel> tasks = [];

    for(int i = 0; i < items.length; i++) {
      tasks.add(TasksModel.fromJson(items[i]));
    }
    return tasks;
  }

  static List<TasksModel> fetchSubtasks(List data) {
    List items = data;
    List<TasksModel> subtasks = [];

    for(int i = 0; i< items.length; i ++) {
      subtasks.add(TasksModel.fromJson(items[i]));
    }
    return subtasks;
  }

  static List<TeamModel> fetchMembers(List data) {
    List items = data;
    List<TeamModel> members = [];

    for(int i = 0; i < items.length; i++) {
      members.add(TeamModel.fromJson(items[i]));
    }

    return members;
  }

}
