/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:icrm/core/models/status_model.dart';
import 'package:icrm/core/service/api/get_status.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/features/presentation/blocs/project_statuses_bloc/project_statuses_event.dart';
import 'package:icrm/features/presentation/blocs/project_statuses_bloc/project_statuses_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectStatusBloc extends Bloc<ProjectStatusesEvent, ProjectStatusState>{

  ProjectStatusBloc(ProjectStatusState initialState) : super(initialState) {
    on<ProjectStatusesInitEvent>((event, emit) async{
      try {
        List<StatusModel> list = await getIt.get<GetStatus>().getStatus(type: 'project');

        emit(ProjectStatusInitState(projectStatuses: list));
      } catch(e) {
        print(e);
        emit(ProjectStatusErrorState(error: "something_went_wrong"));
      }
    });

  }

}