import 'package:avlo/core/models/dash_board_model.dart';
import 'package:avlo/core/models/leads_model.dart';
import 'package:avlo/core/models/leads_status_model.dart';
import 'package:avlo/core/service/api/get_dash_board.dart';
import 'package:avlo/core/service/api/get_leads.dart';
import 'package:avlo/core/service/api/get_leads_status.dart';
import 'package:avlo/core/util/get_it.dart';
import 'package:avlo/features/presentation/blocs/home_bloc/home_event.dart';
import 'package:avlo/features/presentation/blocs/home_bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(HomeState initialState) : super(initialState) {
    on<HomeInitEvent>((event, emit) async {
      emit(HomeLoadingState());

      try {
        List<LeadsModel> leads = await getIt.get<GetLeads>().getLeads();
        List<DashBoardModel> dashboard =
            await getIt.get<GetDashBoard>().getDashBoard();
        List<LeadsStatusModel> leadStatuses = await getIt.get<GetLeadsStatus>().getLeadsStatus();

        emit(HomeInitState(
          leads: leads,
          dashboard: dashboard,
          leadStatus: leadStatuses,
        ));
      } catch (error) {
        print(error);

        emit(HomeErrorState(error: error.toString()));
      }
    });

    on<LeadsDeleteEvent>((event, emit) async {
      try {
        bool result = await getIt.get<GetLeads>().deleteLeads(id: event.id);

        if (result) {
          List<LeadsModel> leads = await getIt.get<GetLeads>().getLeads();
          List<DashBoardModel> dashboard =
              await getIt.get<GetDashBoard>().getDashBoard();
          List<LeadsStatusModel> leadStatuses = await getIt.get<GetLeadsStatus>().getLeadsStatus();

          emit(HomeInitState(
            leads: leads,
            dashboard: dashboard,
            leadStatus: leadStatuses,
          ));
        } else {
          emit(HomeErrorState(error: "something_went_wrong"));
        }
      } catch (e) {
        print(e);
        emit(HomeErrorState(error: e.toString()));
      }
    });

    on<LeadsAddEvent>((event, emit) async {
      emit(HomeLoadingState());

      try {
        LeadsModel lead = await getIt.get<GetLeads>().addLeads(
              projectId: event.projectId,
              seller_id: event.seller_id,
              description: event.description,
              contactId: event.contactId,
              estimated_amount: event.estimated_amount,
              startDate: event.startDate,
              endDate: event.endDate,
              leadStatus: event.leadStatus,
              currency: event.currency,
            );

        emit(LeadAddSuccessState(lead: lead));
      } catch (error) {
        print(error);
        emit(HomeErrorState(error: error.toString()));
      }
    });

    on<LeadsUpdateEvent>((event, emit) async {
      emit(HomeLoadingState());

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
          if(event.fromHome) {
            List<LeadsModel> leads = await getIt.get<GetLeads>().getLeads();
            List<DashBoardModel> dashboard =
            await getIt.get<GetDashBoard>().getDashBoard();

            List<LeadsStatusModel> leadStatuses = await getIt.get<GetLeadsStatus>().getLeadsStatus();

            emit(HomeInitState(
              leads: leads,
              dashboard: dashboard,
              leadStatus: leadStatuses,
            ));
          }else {
            final LeadsModel lead = await getIt.get<GetLeads>().showLeads(id: event.id);
            final List<LeadsStatusModel> leadStatuses = await getIt.get<GetLeadsStatus>().getLeadsStatus();

            emit(LeadShowState(
              lead: lead,
              leadStatus: leadStatuses,
            ));
          }
        } else {
          emit(HomeErrorState(error: result));
        }
      } catch (error) {
        print(error);
        emit(HomeErrorState(error: error.toString()));
      }
    });

    on<LeadsShowEvent>((event, emit) async {
      emit(HomeLoadingState());

      try {

        final LeadsModel lead = await getIt.get<GetLeads>().showLeads(id: event.id);
        final List<LeadsStatusModel> leadStatuses = await getIt.get<GetLeadsStatus>().getLeadsStatus();

        emit(LeadShowState(
          lead: lead,
          leadStatus: leadStatuses,
        ));

      } catch(error) {
        print(error);

        emit(HomeErrorState(error: error.toString()));
      }

    });


    on<LeadsAddStatusEvent>((event, emit) async {

      emit(HomeLoadingState());

      try {
        bool result = await getIt.get<GetLeadsStatus>().addLeadsStatus(name: event.name);

        if(result) {
          List<LeadsModel> leads = await getIt.get<GetLeads>().getLeads();
          List<DashBoardModel> dashboard =
          await getIt.get<GetDashBoard>().getDashBoard();
          List<LeadsStatusModel> leadStatuses = await getIt.get<GetLeadsStatus>().getLeadsStatus();

          emit(HomeInitState(
            leads: leads,
            dashboard: dashboard,
            leadStatus: leadStatuses,
          ));
        }else {
          emit(HomeErrorState(error: 'something_went_wrong'));
        }

      }
      catch(error) {
        print(error);

        emit(HomeErrorState(error: error.toString()));
      }

    });

    on<LeadsStatusUpdateEvent>((event, emit) async {

      emit(HomeLoadingState());

      try {

        bool result = await getIt.get<GetLeadsStatus>().updateLeadsStatus(id: event.id, name: event.name);
        if(result) {
          List<LeadsModel> leads = await getIt.get<GetLeads>().getLeads();
          List<DashBoardModel> dashboard =
          await getIt.get<GetDashBoard>().getDashBoard();
          List<LeadsStatusModel> leadStatuses = await getIt.get<GetLeadsStatus>().getLeadsStatus();

          emit(HomeInitState(
            leads: leads,
            dashboard: dashboard,
            leadStatus: leadStatuses,
          ));
        }else {
          emit(HomeErrorState(error: 'something_went_wrong'));
        }

      } catch(error) {
        print(error);

        emit(HomeErrorState(error: error.toString()));
      }

    });

    on<LeadsStatusDeleteEvent>((event, emit) async {

      emit(HomeLoadingState());

      try {

        bool result = await getIt.get<GetLeadsStatus>().deleteLeadsStatus(id: event.id);

        if(result) {
          List<LeadsModel> leads = await getIt.get<GetLeads>().getLeads();
          List<DashBoardModel> dashboard =
          await getIt.get<GetDashBoard>().getDashBoard();
          List<LeadsStatusModel> leadStatuses = await getIt.get<GetLeadsStatus>().getLeadsStatus();

          emit(HomeInitState(
            leads: leads,
            dashboard: dashboard,
            leadStatus: leadStatuses,
          ));
        }else {
          emit(HomeErrorState(error: 'something_went_wrong'));
        }

      } catch(error) {
        print(error);

        emit(HomeErrorState(error: error.toString()));
      }

    });
  }
}
