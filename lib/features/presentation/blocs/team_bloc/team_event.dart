
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

class TeamDeleteEvent extends TeamEvent {
  final String id;

  TeamDeleteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class TeamUpdateEvent extends TeamEvent {
  final String name;
  final String position;
  final String email;
  final String phone_number;

  TeamUpdateEvent({required this.email, required this.phone_number, required this.position, required this.name});

  @override
  List<Object?> get props => [email, position, phone_number, name];
}

class TeamShowEvent extends TeamEvent {
  final int id;

  TeamShowEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

