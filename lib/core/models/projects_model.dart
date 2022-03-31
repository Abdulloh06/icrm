
import 'package:avlo/core/models/leads_model.dart';
import 'package:avlo/core/models/project_statuses_model.dart';
import 'package:avlo/core/models/tasks_model.dart';
import 'package:avlo/core/models/team_model.dart';
import 'package:avlo/core/models/user_categories_model.dart';

class ProjectsModel {
  final int id;
  final int user_id;
  final int project_status_id;
  final int user_category_id;
  final int company_id;
  final String name;
  final String description;
  final String notify_at;
  final dynamic price;
  final String share;
  final String currency;
  final String created_at;
  final String updated_at;
  final bool isOwner;
  final List<LeadsModel>? leads;
  final List<TasksModel>? tasks;
  final List<TeamModel>? members;
  final UserCategoriesModel? userCategory;
  final ProjectStatusesModel? projectStatus;

  ProjectsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.user_id,
    required this.company_id,
    required this.project_status_id,
    required this.user_category_id,
    required this.notify_at,
    required this.price,
    required this.share,
    required this.currency,
    required this.created_at,
    required this.updated_at,
    required this.isOwner,
    this.userCategory,
    this.leads,
    this.tasks,
    this.members,
    this.projectStatus,
  });

  factory ProjectsModel.fromJson(Map<String, dynamic> json) {

    UserCategoriesModel? user_category;
    if(json['userCategory'] != null) {
      user_category = UserCategoriesModel.fromJson(json['userCategory']);
    }

    ProjectStatusesModel? projectStatusesModel;
    if(json['projectStatus'] != null) {
      projectStatusesModel = ProjectStatusesModel.fromJson(json['projectStatus']);
    }

    return ProjectsModel(
      id: json['id'],
      user_id: json['user_id'],
      project_status_id: json['project_status_id'],
      user_category_id: json['user_category_id'],
      company_id: json['company_id'] ?? 0,
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      notify_at: json['notify_at'] ?? "",
      price: json['price'],
      share: json['share'] ?? "",
      currency: json['currency'] ?? "",
      created_at: json['created_at'] ?? "",
      updated_at: json['updated_at'] ?? "",
      isOwner: json['isOwner'] ?? true,
      leads: fetchLeads(json['leads'] ?? []),
      tasks: fetchTasks(json['tasks'] ?? []),
      userCategory: user_category,
      projectStatus: projectStatusesModel,
      members: fetchMembers(json['members'] ?? []),
    );
  }

  static List<ProjectsModel> fetchData(Map<String, dynamic> data) {
    List items = data['data'];
    List<ProjectsModel> projects = [];

    for (int i = 0; i < items.length; i++) {
      projects.add(ProjectsModel.fromJson(items[i]));
    }

    return projects;
  }

  static List<LeadsModel> fetchLeads(List data) {
    List item = data;
    List<LeadsModel> leads = [];

    for(int i = 0; i < item.length; i++) {
      leads.add(LeadsModel.fromJson(item[i]));
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

  static List<TeamModel> fetchMembers(List data) {
    List items = data;
    List<TeamModel> members = [];

    for(int i = 0; i < items.length; i++) {
      members.add(TeamModel.fromJson(items[i]));
    }

    return members;
  }

}
