import 'package:icrm/core/models/team_model.dart';
import 'package:equatable/equatable.dart';

abstract class HelperState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HelperInitState extends HelperState {}

class HelperLeadMemberState extends HelperState {
  final TeamModel member;

  HelperLeadMemberState({required this.member});
}

class HelperProjectMemberState extends HelperState {
  final TeamModel member;

  HelperProjectMemberState({required this.member});
}

class HelperLeadDateState extends HelperState {
  final String start_date;
  final String deadline;

  HelperLeadDateState({required this.deadline, required this.start_date});
}

class HelperProjectDateState extends HelperState {
  final String start_date;
  final String deadline;

  HelperProjectDateState({required this.start_date,required this.deadline});
}

class HelperTaskMemberState extends HelperState {
  final TeamModel team;

  HelperTaskMemberState({required this.team});
}

class HelperTaskDateState extends HelperState {
  final String start_date;
  final String deadline;

  HelperTaskDateState({required this.start_date,required this.deadline});
}

class HelperLeadContactState extends HelperState {
  final int id;
  final String name;

  HelperLeadContactState({
    required this.id,
    required this.name,
  });
}

class HelperLoadingState extends HelperState {}

class HelperErrorState extends HelperState {
  final String error;

  HelperErrorState({required this.error});
}