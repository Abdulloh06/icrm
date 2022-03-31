import 'package:avlo/core/models/project_statuses_model.dart';
import 'package:avlo/core/models/projects_model.dart';
import 'package:avlo/core/service/api/get_project_statuses.dart';
import 'package:avlo/core/service/api/get_projects.dart';
import 'package:avlo/core/util/get_it.dart';
import 'package:avlo/features/presentation/blocs/projects_bloc/projects_event.dart';
import 'package:avlo/features/presentation/blocs/projects_bloc/projects_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc(ProjectsState initialState) : super(initialState) {
    on<ProjectsInitEvent>((event, emit) async {
      emit(ProjectsLoadingState());

      try {
        final List<ProjectsModel> projects =
            await getIt.get<GetProjects>().getProjects();

        emit(ProjectsInitState(projects: projects));
      } catch (error) {
        print(error);
        emit(ProjectsErrorState(error: error.toString()));
      }
    });

    on<ProjectsAddEvent>((event, emit) async {
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
        );

        emit(ProjectsAddSuccessState(project: project));
      } catch (error) {
        print(error);

        emit(ProjectsErrorState(error: error.toString()));
      }
    });

    on<ProjectsUpdateEvent>((event, emit) async {
      emit(ProjectsLoadingState());

      try {
        bool result = await getIt.get<GetProjects>().updateProject(
          id: event.id,
          name: event.name,
          description: event.description,
          company_id: event.company_id,
          user_category_id: event.user_category_id,
          project_status_id: event.project_status_id,
        );

        if(result) {
          List<ProjectStatusesModel> projectStatuses = await getIt.get<GetProjectStatuses>().getProjectStatuses();
          ProjectsModel project = await getIt.get<GetProjects>().showProject(id: event.id);

          emit(ProjectsShowState(
            project: project,
            projectsStatuses: projectStatuses,
          ));
        }else {
          emit(ProjectsErrorState(error: 'something_went_wrong'));
        }
      } catch (error) {
        print(error);
        emit(ProjectsErrorState(error: error.toString()));
      }
    });

    on<ProjectsShowEvent>((event, emit) async {
      emit(ProjectsLoadingState());

      try {
        ProjectsModel project =
            await getIt.get<GetProjects>().showProject(id: event.id);

        List<ProjectStatusesModel> projectStatuses = await getIt.get<GetProjectStatuses>().getProjectStatuses();

        emit(ProjectsShowState(
          project: project,
          projectsStatuses: projectStatuses,
        ));
      } catch (error) {
        print(error);

        emit(ProjectsErrorState(error: error.toString()));
      }
    });

    on<ProjectsNameEvent>((event, emit) {
      try {
        emit(ProjectsNameState(
          contact_id: event.contact_id,
          contact_name: event.name,
        ));
      } catch (error) {
        print(error);
        emit(ProjectsErrorState(error: error.toString()));
      }
    });

    on<ProjectsCompanyEvent>((event, emit) {
      try {
        emit(ProjectsCompanyState(
          company_id: event.company_id,
          name: event.name,
        ));
      } catch (error) {
        print(error);
        emit(ProjectsErrorState(error: error.toString()));
      }
    });

    on<ProjectsUserCategoryEvent>((event, emit) {
      try {
        emit(ProjectsUserCategoryState(id: event.id, name: event.name));
      } catch (error) {
        print(error);
        emit(ProjectsErrorState(error: error.toString()));
      }
    });

    on<ProjectsAddStatusEvent>((event, emit) {
      try {
        emit(ProjectsAddStatusState(id: event.id, name: event.name));
      } catch (error) {
        print(error);
        emit(ProjectsErrorState(error: error.toString()));
      }
    });

    on<ProjectsDeleteEvent>((event, emit) async {

      try {

        bool result = await getIt.get<GetProjects>().deleteProject(id: event.id);

        if(result) {

          final List<ProjectsModel> projects =
          await getIt.get<GetProjects>().getProjects();

          emit(ProjectsInitState(projects: projects));

        }else {
          emit(ProjectsErrorState(error: 'something_went_wrong'));
        }

      } catch(error) {
        print(error);

        emit(ProjectsErrorState(error: error.toString()));
      }

    });
  }
}
