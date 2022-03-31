class LeadsTasks {
  Data? data;

  LeadsTasks({this.data});

  LeadsTasks.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? projectId;
  int? contactId;
  dynamic estimatedAmount;
  String? startDate;
  String? endDate;
  int? leadStatusId;
  int? clientId;
  String? channelId;
  int? createdBy;
  int? updatedBy;
  String? createdAt;
  String? updatedAt;
  List<Tasks>? tasks;

  Data(
      {this.id,
      this.projectId,
      this.contactId,
      this.estimatedAmount,
      this.startDate,
      this.endDate,
      this.leadStatusId,
      this.clientId,
      this.channelId,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.tasks});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectId = json['project_id'];
    contactId = json['contact_id'];
    estimatedAmount = json['estimated_amount'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    leadStatusId = json['lead_status_id'];
    clientId = json['client_id'];
    channelId = json['channel_id'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['tasks'] != null) {
      tasks = <Tasks>[];
      json['tasks'].forEach((v) {
        tasks!.add(new Tasks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['project_id'] = this.projectId;
    data['contact_id'] = this.contactId;
    data['estimated_amount'] = this.estimatedAmount;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['lead_status_id'] = this.leadStatusId;
    data['client_id'] = this.clientId;
    data['channel_id'] = this.channelId;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.tasks != null) {
      data['tasks'] = this.tasks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tasks {
  int? id;
  int? parentId;
  int? taskStatusId;
  String? startDate;
  String? deadline;
  int? priority;
  String? name;
  String? description;
  String? taskableType;
  int? taskableId;
  String? createdAt;
  String? updatedAt;

  Tasks(
      {this.id,
      this.parentId,
      this.taskStatusId,
      this.startDate,
      this.deadline,
      this.priority,
      this.name,
      this.description,
      this.taskableType,
      this.taskableId,
      this.createdAt,
      this.updatedAt});

  Tasks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    taskStatusId = json['task_status_id'];
    startDate = json['start_date'];
    deadline = json['deadline'];
    priority = json['priority'];
    name = json['name'];
    description = json['description'];
    taskableType = json['taskable_type'];
    taskableId = json['taskable_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['task_status_id'] = this.taskStatusId;
    data['start_date'] = this.startDate;
    data['deadline'] = this.deadline;
    data['priority'] = this.priority;
    data['name'] = this.name;
    data['description'] = this.description;
    data['taskable_type'] = this.taskableType;
    data['taskable_id'] = this.taskableId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
