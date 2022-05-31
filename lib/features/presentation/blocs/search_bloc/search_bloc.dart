/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/leads_model.dart';
import 'package:icrm/core/models/status_model.dart';
import 'package:icrm/core/models/tasks_model.dart';
import 'package:icrm/core/service/api/get_leads.dart';
import 'package:icrm/core/service/api/get_projects.dart';
import 'package:icrm/core/service/api/get_status.dart';
import 'package:icrm/core/service/api/get_tasks.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/features/presentation/blocs/search_bloc/search_event.dart';
import 'package:icrm/features/presentation/blocs/search_bloc/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/projects_model.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState>{
  SearchBloc(SearchState initialState) : super(initialState) {
    on<SearchInitEvent>((event, emit) => _init(event: event, emit: emit));
    on<SearchProjectEvent>((event, emit) => _projects(event: event, emit: emit));
  }

  Future<void> _init({
    required SearchInitEvent event,
    required Emitter<SearchState> emit,
  }) async {
    emit(SearchLoadingState());

    try {
      final List<LeadsModel> leads = await getIt.get<GetLeads>().getLeads(page: 1, withPagination: false);
      final List<ProjectsModel> projects = await getIt.get<GetProjects>().getProjects(page: 1, withPagination: false);
      final List<TasksModel> tasks = await getIt.get<GetTasks>().getTasks(page: 1, );

      final List<StatusModel> projectStatus = await getIt.get<GetStatus>().getStatus(type: 'project');
      final List<StatusModel> leadStatus = await getIt.get<GetStatus>().getStatus(type: 'lead');
      final List<StatusModel> taskStatus = await getIt.get<GetStatus>().getStatus(type: 'task');

      emit(SearchInitState(
        leads: leads,
        tasks: tasks,
        projects: projects,
        projectStatuses: projectStatus,
        leadStatuses: leadStatus,
        taskStatuses: taskStatus,
      ));
    } catch(error) {
      print(error);
      emit(SearchErrorState(error: 'something_went_wrong'));
    }

  }

  Future<void> _projects({
    required SearchProjectEvent event,
    required Emitter<SearchState> emit,
  }) async {
    emit(SearchLoadingState());

    try {

      final List<ProjectsModel> projects = await getIt.get<GetProjects>().getProjects(page: 1, withPagination: false);

      emit(SearchProjectsState(
        projects: projects,
      ));

    } catch(error) {
      print(error);
      emit(SearchErrorState(error: 'something_went_wrong'));
    }
  }

}