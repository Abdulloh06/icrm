/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:icrm/core/models/dash_board_model.dart';
import 'package:icrm/core/models/leads_model.dart';
import 'package:icrm/core/models/status_model.dart';
import 'package:icrm/core/service/api/get_dash_board.dart';
import 'package:icrm/core/service/api/get_leads.dart';
import 'package:icrm/core/service/api/get_status.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_event.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(HomeState initialState) : super(initialState) {
    on<HomeInitEvent>((event, emit) => _init(event: event, emit: emit));
    on<LeadsDeleteEvent>((event, emit) => _deleteLead(event: event, emit: emit));
    on<LeadsAddEvent>((event, emit) => _addLead(event: event, emit: emit));
    on<LeadsUpdateEvent>((event, emit) => _updateLead(event: event, emit: emit));
    on<LeadsShowEvent>((event, emit) => _showLead(event: event, emit: emit));
    on<LeadsStatusUpdateEvent>((event, emit) =>_updateLeadStatus(event: event, emit: emit));
    on<HomeGetNextPageEvent>((event, emit) => _getNextPage(event: event, emit: emit));
    on<LeadStatusDeleteEvent>((event, emit) => _deleteLeadStatus(event: event, emit: emit));
  }

  Future<void> _init({
    required HomeInitEvent event,
    required Emitter<HomeState> emit,
  }) async {
    emit(HomeLoadingState());

    try {
      HomeGetNextPageEvent.page = 1;
      HomeGetNextPageEvent.hasReachedMax = false;

      List<LeadsModel> leads = await getIt.get<GetLeads>().getLeads(page: 1);
      List<DashBoardModel> dashboard =
      await getIt.get<GetDashBoard>().getDashBoard();
      List<StatusModel> leadStatuses = await getIt.get<GetStatus>().getStatus(
        type: 'lead',
      );

      emit(HomeInitState(
        leads: leads,
        dashboard: dashboard,
        leadStatus: leadStatuses,
      ));
    } catch (error) {
      print(error);

      emit(HomeErrorState(error: error.toString()));
    }
  }

  Future<void> _getNextPage({
    required HomeGetNextPageEvent event,
    required Emitter<HomeState> emit,
  }) async {

    try {

      HomeGetNextPageEvent.page++;
      List<LeadsModel> leads = await getIt.get<GetLeads>().getLeads(page: HomeGetNextPageEvent.page);
      List<DashBoardModel> dashboard = await getIt.get<GetDashBoard>().getDashBoard();
      List<StatusModel> leadStatuses = await getIt.get<GetStatus>().getStatus(
        type: 'lead',
      );

      if(leads.isNotEmpty) {
        emit(HomeInitState(
          leads: event.leads + leads,
          dashboard: dashboard,
          leadStatus: leadStatuses,
        ));
      }else {
        HomeGetNextPageEvent.page--;
        HomeGetNextPageEvent.hasReachedMax = true;
        emit(HomeInitState(
          leads: event.leads,
          dashboard: dashboard,
          leadStatus: leadStatuses,
        ));
      }


    } catch (error) {
      print(error);

      emit(HomeErrorState(error: error.toString()));
    }
  }

  Future<void> _addLead({
    required LeadsAddEvent event,
    required Emitter<HomeState> emit,
  }) async {
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
      print(error.toString() + "IN BLOC ADD");
      emit(HomeErrorState(error: error.toString()));
    }
  }

  Future<void> _deleteLead({
    required LeadsDeleteEvent event,
    required Emitter<HomeState> emit,
  }) async {
    try {
      bool result = await getIt.get<GetLeads>().deleteLeads(id: event.id);

      if (result) {
        List<LeadsModel> leads = await getIt.get<GetLeads>().getLeads(page: 1);
        List<DashBoardModel> dashboard =
        await getIt.get<GetDashBoard>().getDashBoard();
        List<StatusModel> leadStatuses = await getIt.get<GetStatus>().getStatus(
          type: 'lead',
        );

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
  }

  Future<void> _updateLead({
    required LeadsUpdateEvent event,
    required Emitter<HomeState> emit,
  }) async {
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

      print(result);
      List<LeadsModel> leads = await getIt.get<GetLeads>().getLeads(page: 1);
      List<DashBoardModel> dashboard =
      await getIt.get<GetDashBoard>().getDashBoard();

      List<StatusModel> leadStatuses = await getIt.get<GetStatus>().getStatus(
        type: 'lead',
      );

      emit(HomeInitState(
        leads: leads,
        dashboard: dashboard,
        leadStatus: leadStatuses,
      ));
    } catch (error) {
      print(error);
      emit(HomeErrorState(error: error.toString()));
    }
  }

  Future<void> _showLead({
    required LeadsShowEvent event,
    required Emitter<HomeState> emit,
  }) async {
    emit(HomeLoadingState());

    try {

      final LeadsModel lead = await getIt.get<GetLeads>().showLeads(id: event.id);
      final List<StatusModel> leadStatuses = await getIt.get<GetStatus>().getStatus(
        type: 'lead',
      );

      emit(LeadShowState(
        lead: lead,
        leadStatus: leadStatuses,
      ));

    } catch(error) {
      print(error);

      emit(HomeErrorState(error: error.toString()));
    }
  }

  Future<void> _updateLeadStatus({
    required LeadsStatusUpdateEvent event,
    required Emitter<HomeState> emit,
  }) async {
    emit(HomeLoadingState());

    try {

      bool result = await getIt.get<GetStatus>().updateStatus(
        id: event.id,
        name: event.name,
        type: 'lead',
        color: event.color,
      );
      if(result) {
        List<LeadsModel> leads = await getIt.get<GetLeads>().getLeads(page: 1);
        List<DashBoardModel> dashboard =
        await getIt.get<GetDashBoard>().getDashBoard();
        List<StatusModel> leadStatuses = await getIt.get<GetStatus>().getStatus(
          type: 'lead',
        );

        emit(HomeInitState(
          leads: leads,
          dashboard: dashboard,
          leadStatus: leadStatuses,
        ));
      } else {
        emit(HomeErrorState(error: 'something_went_wrong'));
      }

    } catch(error) {
      print(error);

      emit(HomeErrorState(error: error.toString()));
    }

  }

  Future<void> _deleteLeadStatus({
    required LeadStatusDeleteEvent event,
    required Emitter<HomeState> emit,
  }) async {

    emit(HomeLoadingState());

    try {

      bool result = await getIt.get<GetStatus>().deleteStatus(
        type: 'lead',
        id: event.id,
      );
      if(result) {
        List<LeadsModel> leads = await getIt.get<GetLeads>().getLeads(page: 1);
        List<DashBoardModel> dashboard =
        await getIt.get<GetDashBoard>().getDashBoard();
        List<StatusModel> leadStatuses = await getIt.get<GetStatus>().getStatus(
          type: 'lead',
        );

        emit(HomeInitState(
          leads: leads,
          dashboard: dashboard,
          leadStatus: leadStatuses,
        ));
      } else {
        emit(HomeErrorState(error: 'something_went_wrong'));
      }

    } catch(error) {
      print(error);

      emit(HomeErrorState(error: error.toString()));
    }
  }

}
