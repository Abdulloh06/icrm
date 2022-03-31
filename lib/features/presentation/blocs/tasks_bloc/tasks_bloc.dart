import 'package:avlo/core/service/api/get_task_status.dart';
import 'package:avlo/core/service/api/get_tasks.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/models/tasks_model.dart';

import '../../../../core/models/tasks_status_model.dart';
import '../../../../core/util/get_it.dart';

part 'tasks_event.dart';

part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc(TasksState initialState) : super(initialState) {
    on<TasksInitEvent>((event, emit) async {
      try {
        final List<TasksModel> tasks = await getIt.get<GetTasks>().getTasks();
        final List<TaskStatusModel> taskStatus =
            await getIt.get<GetTasksStatus>().getTaskStatuses();
        emit(TasksInitState(
          tasks: tasks,
          tasksStatuses: taskStatus,
        ));
      } catch (e) {
        print(e);
        emit(TasksErrorState(error: e.toString()));
      }
    });

    on<TasksAddEvent>((event, emit) async {
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
    });

    on<TasksAddCommentEvent>((event, emit) async {
      emit(TasksLoadingState());

      try {
        bool result = await getIt.get<GetTasks>().addComment(
          id: event.id,
          comment: event.comment,
          comment_type: event.comment_type,
        );

        TasksModel task = await getIt.get<GetTasks>().showTask(id: event.id);
        final List<TaskStatusModel> taskStatus =
        await getIt.get<GetTasksStatus>().getTaskStatuses();

        if (result) {
          emit(TasksShowState(
            task: task,
            taskStatuses: taskStatus,
          ));
        } else {
          emit(TasksErrorState(error: 'something_went_wrong'));
        }
      } catch (error) {
        print(error);

        emit(TasksErrorState(error: error.toString()));
      }
    });

    on<TasksDeleteEvent>((event, emit) async {
      emit(TasksLoadingState());

      try {
        bool result = await getIt.get<GetTasks>().deleteTask(id: event.id);

        if (result) {
          final List<TasksModel> tasks = await getIt.get<GetTasks>().getTasks();
          final List<TaskStatusModel> taskStatus =
              await getIt.get<GetTasksStatus>().getTaskStatuses();
          emit(TasksInitState(
            tasks: tasks,
            tasksStatuses: taskStatus,
          ));
        } else {
          emit(TasksErrorState(error: 'something_went_wrong'));
        }
      } catch (error) {
        print(error);

        emit(TasksErrorState(error: error.toString()));
      }
    });

    on<TasksUpdateEvent>((event, emit) async {
      emit(TasksLoadingState());

      try {
        int result = await getIt.get<GetTasks>().updateTasks(
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

        emit(TasksUpdateState(id: result));
      } catch (error) {
        print(error);
        emit(TasksErrorState(error: error.toString()));
      }
    });

    on<TasksStatusAddEvent>((event, emit) async {
      emit(TasksLoadingState());

      try {
        bool result =
            await getIt.get<GetTasksStatus>().addTaskStatus(name: event.name);

        if (result) {
          final List<TasksModel> tasks = await getIt.get<GetTasks>().getTasks();
          final List<TaskStatusModel> taskStatus =
              await getIt.get<GetTasksStatus>().getTaskStatuses();
          emit(TasksInitState(
            tasks: tasks,
            tasksStatuses: taskStatus,
          ));
        } else {
          emit(TasksErrorState(error: 'something_went_wrong'));
        }
      } catch (e) {
        print(e);
        emit(TasksErrorState(error: 'something_went_wrong'));
      }
    });

    on<TasksStatusUpdateEvent>((event, emit) async {
      emit(TasksLoadingState());

      try {
        bool result = await getIt
            .get<GetTasksStatus>()
            .updateProjectStatus(id: event.id, name: event.name);

        if (result) {
          final List<TasksModel> tasks = await getIt.get<GetTasks>().getTasks();
          final List<TaskStatusModel> taskStatus =
              await getIt.get<GetTasksStatus>().getTaskStatuses();
          emit(TasksInitState(
            tasks: tasks,
            tasksStatuses: taskStatus,
          ));
        } else {
          emit(TasksErrorState(error: 'something_went_wrong'));
        }
      } catch (e) {
        print(e);
        emit(TasksErrorState(error: 'something_went_wrong'));
      }
    });

    on<TasksStatusDeleteEvent>((event, emit) async {
      emit(TasksLoadingState());

      try {
        bool result =
            await getIt.get<GetTasksStatus>().deleteTaskStatus(id: event.id);

        if (result) {
          final List<TasksModel> tasks = await getIt.get<GetTasks>().getTasks();
          final List<TaskStatusModel> taskStatus =
              await getIt.get<GetTasksStatus>().getTaskStatuses();
          emit(TasksInitState(
            tasks: tasks,
            tasksStatuses: taskStatus,
          ));
        } else {
          emit(TasksErrorState(error: 'something_went_wrong'));
        }
      } catch (e) {
        print(e);
        emit(TasksErrorState(error: 'something_went_wrong'));
      }
    });

    on<TasksAssignUsersEvent>((event, emit) async {
      emit(TasksLoadingState());

      try {



      } catch(error) {
        print(error);
        emit(TasksErrorState(error: error.toString()));
      }

    });

    on<TasksShowEvent>((event, emit) async {
      emit(TasksLoadingState());

      try {

        TasksModel task = await getIt.get<GetTasks>().showTask(id: event.id);
        final List<TaskStatusModel> taskStatus =
        await getIt.get<GetTasksStatus>().getTaskStatuses();

        emit(TasksShowState(
          task: task,
          taskStatuses: taskStatus,
        ));

      } catch (error) {
        print(error);

        emit(TasksErrorState(error: error.toString()));
      }

    });

  }
}
