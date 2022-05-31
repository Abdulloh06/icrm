/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/status_model.dart';
import 'package:icrm/core/service/api/get_status.dart';
import 'package:icrm/core/service/api/get_tasks.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/models/tasks_model.dart';
import '../../../../core/util/get_it.dart';
part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc(TasksState initialState) : super(initialState) {
    on<TasksInitEvent>((event, emit) => _initState(event: event, emit: emit));
    on<TasksGetNextPageEvent>((event, emit) => _getNextPage(event: event, emit: emit, list: event.list));
    on<TasksAddEvent>((event, emit) => _addTask(event: event, emit: emit));
    on<TasksDeleteEvent>((event, emit) => _deleteTask(event: event, emit: emit));
    on<TasksUpdateEvent>((event, emit) => _updateTask(event: event, emit: emit));
    on<TasksStatusUpdateEvent>((event, emit) => _taskStatusUpdate(event: event, emit: emit));
    on<TasksAssignUsersEvent>((event, emit) => _assignUsers(event: event, emit: emit));
    on<TasksDeleteUserEvent>((event, emit) => _deleteUser(event: event, emit: emit));
    on<TasksStatusDeleteEvent>((event, emit) => _deleteTaskStatus(event: event, emit: emit));
  }

  Future<void> _initState({
    required TasksInitEvent event,
    required Emitter<TasksState> emit,
  }) async {
    emit(TasksLoadingState());
    try {
      TasksGetNextPageEvent.page = 1;
      TasksGetNextPageEvent.hasReachedMax = false;
      await _emitInitState(emit: emit);
    } catch (e) {
      print(e);
      emit(TasksErrorState(error: e.toString()));
    }
  }

  Future<void> _getNextPage({
    required TasksGetNextPageEvent event,
    required Emitter<TasksState> emit,
    required List<TasksModel> list,
  }) async {
    try {
      TasksGetNextPageEvent.page++;
      final List<TasksModel> tasks = await getIt.get<GetTasks>().getTasks(page: TasksGetNextPageEvent.page);
      final List<StatusModel> taskStatus = await getIt.get<GetStatus>().getStatus(type: 'task');
      if(tasks.isNotEmpty) {
        emit(TasksInitState(
          tasks: list + tasks,
          tasksStatuses: taskStatus,
        ));
      }else {
        emit(TasksInitState(
          tasks: list,
          tasksStatuses: taskStatus,
        ));
      }
    } catch (e) {
      print(e);
      emit(TasksErrorState(error: e.toString()));
    }
  }

  Future<void> _addTask({
    required TasksAddEvent event,
    required Emitter<TasksState> emit,
  }) async {
    emit(TasksLoadingState());

    try {
      TasksModel task = await getIt.get<GetTasks>().addTasks(
        parent_id: event.parent_id,
        deadline: event.deadline,
        description: event.description,
        name: event.name,
        status: event.status,
        taskId: event.taskId,
        taskType: event.taskType,
        user: event.user,
        start_date: event.start_date,
        priority: event.priority,
      );

      emit(TasksAddState(task: task));
    } catch (error) {
      print(error);
      emit(TasksErrorState(error: 'something_went_wrong'));
    }
  }

  Future<void> _deleteTask({
    required TasksDeleteEvent event,
    required Emitter<TasksState> emit,
  }) async {
    emit(TasksLoadingState());

    try {
      bool result = await getIt.get<GetTasks>().deleteTask(id: event.id);

      if (result) {
        await _emitInitState(emit: emit);
      } else {
        emit(TasksErrorState(error: 'something_went_wrong'));
      }
    } catch (error) {
      print(error);

      emit(TasksErrorState(error: error.toString()));
    }
  }

  Future<void> _updateTask({
    required TasksUpdateEvent event,
    required Emitter<TasksState> emit,
  }) async {
    emit(TasksLoadingState());
    try {
      bool result = await getIt.get<GetTasks>().updateTasks(
        id: event.id,
        parent_id: event.parent_id,
        name: event.name,
        description: event.description,
        status: event.status,
        deadline: event.deadline,
        taskId: event.taskId,
        taskType: event.taskType,
        priority: event.priority,
        start_date: event.start_date,
      );

      if(result) {
        await _emitInitState(emit: emit);
      }else {
        emit(TasksErrorState(error: 'something_went_wrong'));
      }
    } catch (error) {
      print(error);
      emit(TasksErrorState(error: error.toString()));
    }
  }

  Future<void> _taskStatusUpdate({
    required TasksStatusUpdateEvent event,
    required Emitter<TasksState> emit,
  }) async {
    emit(TasksLoadingState());

    try {
      bool result = await getIt.get<GetStatus>().updateStatus(
        id: event.id,
        name: event.name,
        type: 'task',
        color: event.color,
      );

      if (result) {
        await _emitInitState(emit: emit);
      } else {
        emit(TasksErrorState(error: 'something_went_wrong'));
      }
    } catch (e) {
      print(e);
      emit(TasksErrorState(error: 'something_went_wrong'));
    }
  }

  Future<void> _deleteTaskStatus({
    required TasksStatusDeleteEvent event,
    required Emitter<TasksState> emit,
  }) async {
    emit(TasksLoadingState());

    try {
      bool result = await getIt.get<GetStatus>().deleteStatus(
        type: 'task',
        id: event.id,
      );

      if (result) {
        await _emitInitState(emit: emit);
      } else {
        emit(TasksErrorState(error: 'something_went_wrong'));
      }
    } catch (e) {
      print(e);
      emit(TasksErrorState(error: 'something_went_wrong'));
    }
  }

  Future<void> _assignUsers({
    required TasksAssignUsersEvent event,
    required Emitter<TasksState> emit,
  }) async {

    try {

      bool result = await getIt.get<GetTasks>().assignMembers(id: event.id, users: event.users);

      if(result) {
        await _emitInitState(emit: emit);
      }else {
        emit(TasksErrorState(error: 'something_went_wrong'));
      }

    } catch (error) {
      print(error);

      emit(TasksErrorState(error: error.toString()));
    }
  }

  Future<void> _deleteUser({
    required TasksDeleteUserEvent event,
    required Emitter<TasksState> emit,
  }) async {
    try {
      bool result = await getIt.get<GetTasks>().reassignUser(task_id: event.task_id, user_id: event.user);

      if(result) {
        await _emitInitState(emit: emit);
      }else {
        emit(TasksErrorState(error: 'something_went_wrong'));
      }
    } catch(error) {
      print(error);

      emit(TasksErrorState(error: 'something_went_wrong'));
    }
  }

  Future<void> _emitInitState({
    required Emitter<TasksState> emit,
  }) async{
    final List<TasksModel> tasks = await getIt.get<GetTasks>().getTasks(page: 1);
    final List<StatusModel> taskStatus = await getIt.get<GetStatus>().getStatus(type: 'task');
    emit(TasksInitState(
      tasks: tasks,
      tasksStatuses: taskStatus,
    ));
  }
}
