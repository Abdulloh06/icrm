import 'package:avlo/core/models/project_statuses_model.dart';
import 'package:avlo/core/service/api/get_project_statuses.dart';
import 'package:avlo/core/util/get_it.dart';
import 'package:avlo/features/presentation/blocs/project_statuses_bloc/project_statuses_event.dart';
import 'package:avlo/features/presentation/blocs/project_statuses_bloc/project_statuses_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectStatusBloc extends Bloc<ProjectStatusesEvent, ProjectStatusState>{

  ProjectStatusBloc(ProjectStatusState initialState) : super(initialState) {
    on<ProjectStatusesInitEvent>((event, emit) async{
      List<ProjectStatusesModel> list = await getIt.get<GetProjectStatuses>().getProjectStatuses();

      emit(ProjectStatusInitState(projectStatuses: list));
    });

    on<ProjectStatusesAddEvent>((event, emit) async {
      emit(ProjectStatusLoadingState());

      try {
        bool result = await getIt.get<GetProjectStatuses>().addProjectStatus(name: event.name);

        if(result) {
          List<ProjectStatusesModel> list = await getIt.get<GetProjectStatuses>().getProjectStatuses();

          emit(ProjectStatusInitState(projectStatuses: list));
        }else {
          emit(ProjectStatusErrorState(error: 'something_went_wrong'));
        }
      }catch (e) {
        print(e);
        emit(ProjectStatusErrorState(error: 'something_went_wrong'));
      }
    });

    on<ProjectStatusUpdateEvent>((event, emit) async {

      emit(ProjectStatusLoadingState());

      try {

        bool result = await getIt.get<GetProjectStatuses>().updateProjectStatus(id: event.id, name: event.name);

        if(result) {
          List<ProjectStatusesModel> list = await getIt.get<GetProjectStatuses>().getProjectStatuses();

          emit(ProjectStatusInitState(projectStatuses: list));
        }else {
          emit(ProjectStatusErrorState(error: 'something_went_wrong'));
        }

      } catch (error) {
        print(error);
        emit(ProjectStatusErrorState(error: 'something_went_wrong'));
      }

    });

    on<ProjectStatusDeleteEvent>((event, emit) async{

      emit(ProjectStatusLoadingState());

      try {

        bool result = await getIt.get<GetProjectStatuses>().deleteProjectStatus(id: event.id);

        if(result) {
          List<ProjectStatusesModel> list = await getIt.get<GetProjectStatuses>().getProjectStatuses();

          emit(ProjectStatusInitState(projectStatuses: list));
        }else {
          emit(ProjectStatusErrorState(error: 'something_went_wrong'));
        }

      } catch (error) {
        print(error);
        emit(ProjectStatusErrorState(error: 'something_went_wrong'));
      }
    });
  }

}