import 'package:equatable/equatable.dart';

abstract class ShowEvent extends Equatable {}

class ShowLeadEvent extends ShowEvent {
  final int id;

  ShowLeadEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class ShowLeadUpdateEvent extends ShowEvent {

  final int id;
  final int project_id;
  final dynamic contact_id;
  final dynamic estimated_amount;
  final String? start_date;
  final String? end_date;
  final int lead_status;
  final String? description;
  final int? seller_id;
  final String? currency;

  ShowLeadUpdateEvent({
    required this.id,
    required this.project_id,
    required this.contact_id,
    required this.start_date,
    required this.end_date,
    required this.estimated_amount,
    required this.lead_status,
    required this.description,
    required this.seller_id,
    required this.currency,
  });

  @override
  List<Object?> get props => [
    id, project_id, contact_id, start_date, end_date, estimated_amount, lead_status, seller_id, currency,
  ];
}

class ShowProjectEvent extends ShowEvent {
  final int id;

  ShowProjectEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class ShowProjectUpdateEvent extends ShowEvent {
  final int id;
  final String name;
  final String description;
  final int company_id;
  final int user_category_id;
  final int project_status_id;
  final List<int>? members;

  ShowProjectUpdateEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.project_status_id,
    required this.user_category_id,
    required this.company_id,
    required this.members,
  });

  @override
  List<Object?> get props => [
    id, name, description, project_status_id, user_category_id, company_id,
  ];
}

class ShowTaskEvent extends ShowEvent {
  final int id;

  ShowTaskEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class ShowTaskUpdateEvent extends ShowEvent {
  final int id;
  final dynamic parent_id;
  final int status;
  final int priority;
  final String deadline;
  final String name;
  final String description;
  final String taskType;
  final int taskId;
  final String start_date;

  ShowTaskUpdateEvent({
    required this.id,
    required this.name,
    required this.start_date,
    required this.deadline,
    required this.priority,
    required this.description,
    required this.status,
    required this.parent_id,
    required this.taskType,
    required this.taskId,
  });


  @override
  List<Object> get props =>
      [
        id, name, parent_id, status, description, deadline, start_date
      ];
}