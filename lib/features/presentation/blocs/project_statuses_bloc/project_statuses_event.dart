import 'package:equatable/equatable.dart';

abstract class ProjectStatusesEvent extends Equatable {

  @override
  List<Object?> get props => [];

}

class ProjectStatusesInitEvent extends ProjectStatusesEvent {}

class ProjectStatusesAddEvent extends ProjectStatusesEvent {

  final String name;

  ProjectStatusesAddEvent({
    required this.name,
  });

  @override
  List<Object?> get props => [name];

}


class ProjectStatusDeleteEvent extends ProjectStatusesEvent {
  final int id;

  ProjectStatusDeleteEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ProjectStatusUpdateEvent extends ProjectStatusesEvent {
  final String name;
  final int id;

  ProjectStatusUpdateEvent({required this.name, required this.id});

  @override
  List<Object?> get props => [name, id];
}