import 'package:avlo/core/models/team_model.dart';
import 'package:equatable/equatable.dart';

abstract class HelperEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HelperInitEvent extends HelperEvent {}

class HelperLeadMemberEvent extends HelperEvent {
  final TeamModel member;

  HelperLeadMemberEvent({required this.member});
}

class HelperProjectMemberEvent extends HelperEvent {
  final TeamModel member;

  HelperProjectMemberEvent({required this.member});
}

class HelperTaskMemberEvent extends HelperEvent {
  final TeamModel member;

  HelperTaskMemberEvent({required this.member});

}

class HelperLeadDateEvent extends HelperEvent {
  final String start_date;
  final String deadline;

  HelperLeadDateEvent({required this.deadline, required this.start_date});
}

class HelperProjectDateEvent extends HelperEvent {
  final String start_date;
  final String deadline;

  HelperProjectDateEvent({required this.start_date,required this.deadline});
}

class HelperTaskDateEvent extends HelperEvent {
  final String start_date;
  final String deadline;

  HelperTaskDateEvent({required this.start_date, required this.deadline});
}

class HelperLeadContactEvent extends HelperEvent {
  final int id;
  final String name;

  HelperLeadContactEvent({
    required this.name,
    required this.id,
  });
}