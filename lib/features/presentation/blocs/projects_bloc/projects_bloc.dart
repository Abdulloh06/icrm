/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:icrm/core/models/projects_model.dart';
import 'package:icrm/core/service/api/get_projects.dart';
import 'package:icrm/core/service/api/get_status.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_event.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/status_model.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc(ProjectsState initialState) : super(initialState) {
    on<ProjectsInitEvent>((event, emit) => _getProjects(event: event, emit: emit));
    on<ProjectsNextPageEvent>((event, emit) => _getProjectsNextPage(event: event, emit: emit, list: event.list));
    on<ProjectsAddEvent>((event, emit) => _addProject(event: event, emit: emit));
    on<ProjectsUpdateEvent>((event, emit) => _updateProject(event: event, emit: emit));
    on<ProjectsDeleteEvent>((event, emit) => _deleteProject(event: event, emit: emit));
  }

  Future<void> _getProjects({
    required ProjectsInitEvent event,
    required Emitter<ProjectsState> emit,
  }) async {
    emit(ProjectsLoadingState());

    try {

      ProjectsNextPageEvent.page = 1;
      ProjectsNextPageEvent.hasReachedMax = false;
      final List<ProjectsModel> projects = await getIt.get<GetProjects>().getProjects(
        page: 1,
      );
      final List<StatusModel> projectStatus = await getIt.get<GetStatus>().getStatus(type: 'project');

      emit(ProjectsInitState(
        projects: projects,
        projectStatus: projectStatus,
      ));
    } catch (error) {
      print(error);
      emit(ProjectsErrorState(error: error.toString()));
    }
  }

  Future<void> _getProjectsNextPage({
    required ProjectsNextPageEvent event,
    required Emitter<ProjectsState> emit,
    required List<ProjectsModel> list,
  }) async {
    try {
      ProjectsNextPageEvent.page += 1;
      final List<ProjectsModel> projects = await getIt.get<GetProjects>().getProjects(page: ProjectsNextPageEvent.page);
      final List<StatusModel> projectStatus = await getIt.get<GetStatus>().getStatus(type: 'project');

      if(projects.isNotEmpty) {
        print("NOT EMPTY");
        emit(ProjectsInitState(
          projects: list + projects,
          projectStatus: projectStatus,
        ));
      }else {
        ProjectsNextPageEvent.page--;
        ProjectsInitState.hasReachedMax = true;
        emit(ProjectsInitState(
          projects: list,
          projectStatus: projectStatus,
        ));
      }

    } catch (error) {
      print(error);
      emit(ProjectsErrorState(error: error.toString()));
    }
  }

  Future<void> _addProject({
    required ProjectsAddEvent event,
    required Emitter<ProjectsState> emit,
  }) async {
    emit(ProjectsLoadingState());

    try {
      final ProjectsModel project = await getIt.get<GetProjects>().addProjects(
        name: event.name,
        description: event.description,
        user_category_id: event.user_category_id,
        project_status_id: event.project_status_id,
        is_owner: event.is_owner,
        notify_at: event.notify_at,
        price: event.price,
        currency: event.currency,
        companyId: event.company_id,
        members: event.members,
      );

      emit(ProjectsAddSuccessState(project: project));
    } catch (error, stack) {
      print(error);
      print(stack);

      emit(ProjectsErrorState(error: error.toString()));
    }
  }

  Future<void> _updateProject({
    required ProjectsUpdateEvent event,
    required Emitter<ProjectsState> emit,
  }) async {
    emit(ProjectsLoadingState());

    try {
      bool result = await getIt.get<GetProjects>().updateProject(
        id: event.id,
        name: event.name,
        description: event.description,
        company_id: event.company_id,
        user_category_id: event.user_category_id,
        project_status_id: event.project_status_id,
        members: event.users,
      );

      if(result) {
        final List<ProjectsModel> projects = await getIt.get<GetProjects>().getProjects(page: 1);
        final List<StatusModel> projectStatus = await getIt.get<GetStatus>().getStatus(type: 'project');

        emit(ProjectsInitState(
          projects: projects,
          projectStatus: projectStatus,
        ));
      }else {
        emit(ProjectsErrorState(error: 'something_went_wrong'));
      }
    } catch (error) {
      print(error);
      emit(ProjectsErrorState(error: error.toString()));
    }
  }

  Future<void> _deleteProject({
    required ProjectsDeleteEvent event,
    required Emitter<ProjectsState> emit,
  }) async {

    try {

      bool result = await getIt.get<GetProjects>().deleteProject(id: event.id);

      if(result) {

        final List<ProjectsModel> projects = await getIt.get<GetProjects>().getProjects(page: 1);
        final List<StatusModel> projectStatus = await getIt.get<GetStatus>().getStatus(type: 'project');

        emit(ProjectsInitState(
          projects: projects,
          projectStatus: projectStatus,
        ));

      }else {
        emit(ProjectsErrorState(error: 'something_went_wrong'));
      }

    } catch(error) {
      print(error);

      emit(ProjectsErrorState(error: error.toString()));
    }
  }
}
