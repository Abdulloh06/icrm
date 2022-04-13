import 'package:equatable/equatable.dart';
import '../../../../core/models/leads_model.dart';

abstract class HomeEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class HomeInitEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}

class HomeGetNextPageEvent extends HomeEvent {
  static int page = 1;
  static bool hasReachedMax = false;
  final List<LeadsModel> leads;

  HomeGetNextPageEvent({required this.leads});

  @override
  List<Object> get props => [page];
}

class LeadsAddEvent extends HomeEvent {
  final int projectId;
  final dynamic contactId;
  final int? seller_id;
  final dynamic estimated_amount;
  final String? startDate;
  final String? endDate;
  final String? description;
  final int leadStatus;
  final String? currency;

  LeadsAddEvent({
    required this.projectId,
    required this.contactId,
    required this.seller_id,
    required this.estimated_amount,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.leadStatus,
    required this.currency,
  });
}

class LeadsShowEvent extends HomeEvent {
  final int id;

  LeadsShowEvent({required this.id});
}

class LeadsDeleteEvent extends HomeEvent {
  final int id;

  LeadsDeleteEvent({required this.id});
}

class LeadsUpdateEvent extends HomeEvent {
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
  final bool fromHome;

  LeadsUpdateEvent({
    required this.id,
    required this.project_id,
    required this.contact_id,
    required this.start_date,
    required this.end_date,
    required this.estimated_amount,
    required this.lead_status,
    this.description,
    this.seller_id,
    this.currency,
    this.fromHome = true,
  });


}

class LeadsAddStatusEvent extends HomeEvent {
  final String name;

  LeadsAddStatusEvent({required this.name});
}

class LeadsStatusDeleteEvent extends HomeEvent {
  final int id;

  LeadsStatusDeleteEvent({required this.id});
}

class LeadsStatusUpdateEvent extends HomeEvent {
  final int id;
  final String name;

  LeadsStatusUpdateEvent({required this.id, required this.name});
}

class LeadsStatusShowEvent extends HomeEvent {
  final int id;

  LeadsStatusShowEvent({required this.id});
}

