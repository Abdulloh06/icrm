import 'package:avlo/core/models/team_model.dart';
import 'package:equatable/equatable.dart';

abstract class TeamState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeamInitState extends TeamState {
  final List<TeamModel> team;

  TeamInitState({required this.team});

  @override
  List<Object?> get props => [team];
}

class TeamShowState extends TeamState {
  final TeamModel team;

  TeamShowState({required this.team});

  @override
  List<Object?> get props => [team];
}

class TeamLoadingState extends TeamState {}

class TeamErrorState extends TeamState {
  final String error;

  TeamErrorState({required this.error});
}
