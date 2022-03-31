part of 'tasks_bloc.dart';

abstract class TasksEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TasksInitEvent extends TasksEvent {}

class TasksAddEvent extends TasksEvent {
  final dynamic parent_id;
  final int status;
  final int priority;
  final String start_date;
  final String deadline;
  final String name;
  final String description;
  final String taskType;
  final int taskId;
  final List<int> user;

  TasksAddEvent({
    required this.priority,
    required this.status,
    required this.start_date,
    required this.deadline,
    required this.name,
    required this.description,
    required this.taskType,
    required this.taskId,
    required this.user,
    this.parent_id,
  });

  @override
  List<Object> get props =>
      [
        name,
        status,
        description,
        deadline,
        taskId,
        taskType,
        user,
        start_date,
      ];
}

class TasksUpdateEvent extends TasksEvent {
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

  TasksUpdateEvent({
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

class TasksDeleteEvent extends TasksEvent {
  final int id;

  TasksDeleteEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class TasksAddCommentEvent extends TasksEvent {
  final String comment;
  final String comment_type;
  final int id;

  TasksAddCommentEvent({
    required this.id,
    required this.comment,
    required this.comment_type,
  });


}

class TasksDeleteCommentEvent extends TasksEvent {
  final int id;

  TasksDeleteCommentEvent({required this.id});
}

class TasksStatusAddEvent extends TasksEvent {

  final String name;

  TasksStatusAddEvent({
    required this.name,
  });

  @override
  List<Object> get props => [name];

}

class TasksStatusDeleteEvent extends TasksEvent {
  final int id;

  TasksStatusDeleteEvent(this.id);

  @override
  List<Object> get props => [id];
}

class TasksStatusUpdateEvent extends TasksEvent {
  final String name;
  final int id;

  TasksStatusUpdateEvent({required this.name,required this.id});

  @override
  List<Object> get props => [name, id];
}

class TasksAssignUsersEvent extends TasksEvent {
  final int id;
  final List<int> users;

  TasksAssignUsersEvent({required this.users, required this.id});
}

class TasksShowEvent extends TasksEvent {
  final int id;

  TasksShowEvent({required this.id});
}
