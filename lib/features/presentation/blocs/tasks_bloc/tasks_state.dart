part of 'tasks_bloc.dart';

abstract class TasksState extends Equatable {
  @override
  List<Object> get props => [];
}

class TasksInitState extends TasksState {
  final List<TasksModel> tasks;
  final List<TaskStatusModel> tasksStatuses;

  TasksInitState({required this.tasks, required this.tasksStatuses});

  @override
  List<Object> get props => [tasks];
}

class TasksAddState extends TasksState {
  final TasksModel task;

  TasksAddState({required this.task});
}

class TasksShowState extends TasksState {
  final TasksModel task;
  final List<TaskStatusModel> taskStatuses;

  TasksShowState({
    required this.task,
    required this.taskStatuses,
  });
}


class TasksUpdateState extends TasksState {
  final int id;

  TasksUpdateState({required this.id});
}

class TasksErrorState extends TasksState {
  final String error;

  TasksErrorState({required this.error});

  @override
  List<Object> get props => [error];

}

class TasksLoadingState extends TasksState {}