import 'package:icrm/core/models/leads_model.dart';
import 'package:icrm/core/models/leads_status_model.dart';
import 'package:icrm/core/models/project_statuses_model.dart';
import 'package:icrm/core/models/projects_model.dart';
import 'package:icrm/core/models/tasks_model.dart';
import 'package:icrm/core/models/tasks_status_model.dart';
import 'package:icrm/core/service/api/get_leads.dart';
import 'package:icrm/core/service/api/get_project_statuses.dart';
import 'package:icrm/core/service/api/get_projects.dart';
import 'package:icrm/core/service/api/get_task_status.dart';
import 'package:icrm/core/service/api/get_tasks.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/features/presentation/blocs/show_bloc/show_event.dart';
import 'package:icrm/features/presentation/blocs/show_bloc/show_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/service/api/get_leads_status.dart';

class ShowBloc extends Bloc<ShowEvent, ShowState> {
  ShowBloc(ShowState initialState) : super(initialState) {

    on<ShowLeadEvent>((event, emit) => _showLead(event: event, emit: emit));
    on<ShowProjectEvent>((event, emit) => _showProject(event: event, emit: emit));
    on<ShowTaskEvent>((event, emit) => _showTask(event: event, emit: emit));
    on<ShowTaskUpdateEvent>((event, emit) => _updateTask(event: event, emit: emit));
    on<ShowLeadUpdateEvent>((event, emit) => _updateLead(event: event, emit: emit));
    on<ShowProjectUpdateEvent>((event, emit) => _updateProject(event: event, emit: emit));
  }

  Future<void> _showLead({
    required ShowLeadEvent event,
    required Emitter<ShowState> emit,
  }) async {

    emit(ShowLoadingState());

    try {

      LeadsModel lead = await getIt.get<GetLeads>().showLeads(id: event.id);
      List<LeadsStatusModel> leadStatus = await getIt.get<GetLeadsStatus>().getLeadsStatus();

      emit(ShowLeadState(
        lead: lead,
        leadStatus: leadStatus,
      ));

    } catch(error) {
      print(error);

      emit(ShowErrorState(error: 'something_went_wrong'));
    }

  }

  Future<void> _updateLead({
    required ShowLeadUpdateEvent event,
    required Emitter<ShowState> emit,
  }) async {
    emit(ShowLoadingState());

    try {
      String result = await getIt.get<GetLeads>().updateLeads(
        id: event.id,
        projectId: event.project_id,
        contactId: event.contact_id,
        estimatedAmount: event.estimated_amount,
        startDate: event.start_date,
        endDate: event.end_date,
        leadStatusId: event.lead_status,
        currency: event.currency,
        seller_id: event.seller_id,
        description: event.description,
      );

      if (result == '') {
        final LeadsModel lead = await getIt.get<GetLeads>().showLeads(id: event.id);
        final List<LeadsStatusModel> leadStatuses = await getIt.get<GetLeadsStatus>().getLeadsStatus();

        emit(ShowLeadState(
          lead: lead,
          leadStatus: leadStatuses,
        ));
      } else {
        emit(ShowErrorState(error: result));
      }
    } catch (error) {
      print(error);
      emit(ShowErrorState(error: error.toString()));
    }
  }

  Future<void> _showProject({
    required ShowProjectEvent event,
    required Emitter<ShowState> emit,
  }) async {

    emit(ShowLoadingState());

    try {

      ProjectsModel project = await getIt.get<GetProjects>().showProject(id: event.id);
      List<ProjectStatusesModel> projectsStatuses = await getIt.get<GetProjectStatuses>().getProjectStatuses();
      emit(ShowProjectState(
        project: project,
        projectsStatuses: projectsStatuses,
      ));

    } catch(error) {
      print(error);

      emit(ShowErrorState(error: 'something_went_wrong'));
    }

  }

  Future<void> _updateProject({
    required ShowProjectUpdateEvent event,
    required Emitter<ShowState> emit,
  }) async {
    emit(ShowLoadingState());

    try {
      bool result = await getIt.get<GetProjects>().updateProject(
        id: event.id,
        name: event.name,
        description: event.description,
        company_id: event.company_id,
        user_category_id: event.user_category_id,
        project_status_id: event.project_status_id,
        members: event.members,
      );

      if(result) {
        ProjectsModel project = await getIt.get<GetProjects>().showProject(id: event.id);
        List<ProjectStatusesModel> projectsStatuses = await getIt.get<GetProjectStatuses>().getProjectStatuses();
        emit(ShowProjectState(
          project: project,
          projectsStatuses: projectsStatuses,
        ));
      }else {
        emit(ShowErrorState(error: 'something_went_wrong'));
      }

    } catch(error) {
      print(error);

      emit(ShowErrorState(error: 'something_went_wrong'));
    }

  }

  Future<void> _showTask({
    required ShowTaskEvent event,
    required Emitter<ShowState> emit,
  }) async {
    emit(ShowLoadingState());

    try {

      TasksModel task = await getIt.get<GetTasks>().showTask(id: event.id);
      List<TaskStatusModel> taskStatuses = await getIt.get<GetTasksStatus>().getTaskStatuses();

      emit(ShowTaskState(
        task: task,
        taskStatuses: taskStatuses,
      ));

    } catch(error) {
      print(error);

      emit(ShowErrorState(error: 'something_went_wrong'));
    }
  }

  Future<void> _updateTask({
    required ShowTaskUpdateEvent event,
    required Emitter<ShowState> emit,
  }) async {
    emit(ShowLoadingState());

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
      print(result);

      emit(ShowTaskUpdateState());

    } catch(error) {
      print(error);

      emit(ShowErrorState(error: 'something_went_wrong'));
    }
  }
}