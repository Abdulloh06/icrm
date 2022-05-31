/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/leads_model.dart';
import 'package:icrm/core/models/projects_model.dart';
import 'package:icrm/core/models/tasks_model.dart';
import 'package:icrm/core/service/api/get_leads.dart';
import 'package:icrm/core/service/api/get_projects.dart';
import 'package:icrm/core/service/api/get_tasks.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/features/presentation/blocs/archive_bloc/archive_event.dart';
import 'package:icrm/features/presentation/blocs/archive_bloc/archive_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ArchiveBloc extends Bloc<ArchiveEvent, ArchiveState>{
  bool hasReachedMax = false;
  ArchiveBloc(ArchiveState initialState) : super(initialState) {
    on<ArchiveInitEvent>((event, emit) => _initState(event: event, emit: emit));
  }

  Future<void> _initState({
    required ArchiveInitEvent event,
    required Emitter<ArchiveState> emit,
  }) async {

    emit(ArchiveLoadingState());

    try {
      final List<ProjectsModel> projects = await getIt.get<GetProjects>().getProjects(page: 1, trash: true, withPagination: false);
      final List<LeadsModel> leads = await getIt.get<GetLeads>().getLeads(page: 1, trash: true, withPagination: false);
      final List<TasksModel> tasks = await getIt.get<GetTasks>().getTasks(page: 1, trash: true, withPagination: false);

      emit(ArchiveInitState(
        tasks: tasks,
        leads: leads,
        projects: projects,
      ));
    } catch(error) {
      print(error);
      emit(ArchiveErrorState(error: 'something_went_wrong'));
    }

  }

}