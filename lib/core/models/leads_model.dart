/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/contacts_model.dart';
import 'package:icrm/core/models/status_model.dart';
import 'package:icrm/core/models/message_model.dart';
import 'package:icrm/core/models/projects_model.dart';
import 'package:icrm/core/models/tasks_model.dart';
import 'package:icrm/core/models/team_model.dart';
import 'package:flutter/foundation.dart';

@immutable
class LeadsModel {
  final int id;
  final int projectId;
  final dynamic contactId;
  final dynamic estimatedAmount;
  final String startDate;
  final String endDate;
  final int leadStatusId;
  final dynamic seller_id;
  final dynamic clientId;
  final dynamic channelId;
  final dynamic createdBy;
  final dynamic updatedBy;
  final String createdAt;
  final String updatedAt;
  final dynamic currency;
  final String description;
  final ProjectsModel? project;
  final ContactModel? contact;
  final StatusModel? leadStatus;
  final List<TasksModel>? tasks;
  final TeamModel? member;
  final List<MessageModel>? messages;

  LeadsModel({
    required this.id,
    required this.projectId,
    required this.contactId,
    required this.estimatedAmount,
    required this.startDate,
    required this.endDate,
    required this.leadStatusId,
    required this.clientId,
    required this.channelId,
    required this.createdBy,
    required this.updatedBy,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.currency,
    required this.seller_id,
    this.project,
    this.contact,
    this.leadStatus,
    this.tasks,
    this.member,
    this.messages,
  });

  factory LeadsModel.fromJson(Map<String, dynamic> json) {
    ProjectsModel? projectsModel;
    if(json['project'] != null) {
       projectsModel = ProjectsModel.fromJson(json['project']);
    }
    ContactModel? contact;
    if(json['contact'] != null) {
      contact = ContactModel.fromJson(json['contact']);
    }
    StatusModel? leadsStatus;
    if(json['label'] != null) {
      leadsStatus = StatusModel.fromJson(json['label']);
    }

    TeamModel? teamModel;
    if(json['seller'] != null) {
      teamModel = TeamModel.fromJson(json['seller']);
    }

    return LeadsModel(
      id: json['id'],
      projectId: json['project_id'],
      contactId: json['contact_id'],
      estimatedAmount: json['estimated_amount'],
      startDate: json['start_date'] ?? "",
      endDate: json['end_date'] ?? "",
      leadStatusId: json['label_id'],
      seller_id: json['seller_id'],
      clientId: json['client_id'] ?? 0,
      channelId: json['channel_id'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      currency: json['currency'],
      description: json['description'] ?? "",
      project: projectsModel,
      contact: contact,
      leadStatus: leadsStatus,
      tasks: fetchTasks(json['tasks'] ?? []),
      member: teamModel,
      messages: fetchMessage(json['messages'] ?? []),
    );
  }

  static List<LeadsModel> fetchData(Map<String, dynamic> data) {
    List items = data['data'];
    List<LeadsModel> leads = [];

    for(int i = 0; i < items.length; i++) {
      leads.add(LeadsModel.fromJson(items[i]));
    }
    return leads;
  }

  static List<TasksModel> fetchTasks(List data) {
    List item = data;
    List<TasksModel> tasks = [];

    for(int i = 0; i < item.length; i++) {
      tasks.add(TasksModel.fromJson(item[i]));
    }
    return tasks;
  }

  static List<MessageModel> fetchMessage(List data) {
    List items = data;
    List<MessageModel> messages = [];

    for(int i = 0; i < items.length; i++) {
      messages.add(MessageModel.fromJson(items[i]));
    }

    return messages;
  }
}


