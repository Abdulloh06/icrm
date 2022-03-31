import 'package:avlo/core/models/dash_board_model.dart';
import 'package:avlo/core/models/leads_model.dart';
import 'package:avlo/core/models/leads_status_model.dart';
import 'package:equatable/equatable.dart';


abstract class HomeState extends Equatable {

  @override
  List<Object?> get props => [];
}

class HomeInitState extends HomeState {
  final List<LeadsModel> leads;
  final List<DashBoardModel> dashboard;
  final List<LeadsStatusModel> leadStatus;

  HomeInitState({
    required this.leads,
    required this.dashboard,
    required this.leadStatus,
  });

  @override
  List<Object?> get props => [leads, dashboard];
}

class LeadAddSuccessState extends HomeState {
  final LeadsModel lead;

  LeadAddSuccessState({required this.lead});
}

class LeadShowState extends HomeState {
  final LeadsModel lead;
  final List<LeadsStatusModel> leadStatus;

  LeadShowState({
    required this.lead,
    required this.leadStatus,
  });
}

class HomeLoadingState extends HomeState {}

class HomeErrorState extends HomeState {

  final String error;

  HomeErrorState({required this.error});

  @override
  List<Object?> get props => [];
}