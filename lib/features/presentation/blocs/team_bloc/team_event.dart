/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:equatable/equatable.dart';


abstract class TeamEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeamInitEvent extends TeamEvent {}

class TeamAddEvent extends TeamEvent {
  final int id;

  TeamAddEvent({
    required this.id,
  });

  @override
  List<Object?> get props => [];
}

class TeamUpdateEvent extends TeamEvent {
  final List<int> team;
  final List<bool> isOften;

  TeamUpdateEvent({
    required this.team,
    required this.isOften,
  });

  @override
  List<Object?> get props => [team, isOften];
}

class TeamInviteEvent extends TeamEvent {
  final String via;
  final String model_type;
  final int model_id;

  TeamInviteEvent({
    required this.via,
    required this.model_type,
    required this.model_id,
  });

  @override
  List<Object?> get props => [via, model_id, model_type];
}
