

import 'package:icrm/features/presentation/blocs/helper_bloc/helper_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'helper_event.dart';

class HelperBloc extends Bloc<HelperEvent, HelperState> {
  HelperBloc(HelperState initialState) : super(HelperLoadingState()) {

    on<HelperInitEvent>((event, emit) async => emit(HelperInitState()));
    on<HelperLeadMemberEvent>((event, emit) async => emit(HelperLeadMemberState(member: event.member)));
    on<HelperProjectMemberEvent>((event, emit) async => emit(HelperProjectMemberState(member: event.member)));
    on<HelperLeadDateEvent>((event, emit) async => emit(HelperLeadDateState(deadline: event.deadline, start_date: event.start_date)));
    on<HelperProjectDateEvent>((event, emit) async => emit(HelperProjectDateState(deadline: event.deadline, start_date: event.start_date)));
    on<HelperTaskMemberEvent>((event, emit) async => emit(HelperTaskMemberState(team: event.member)));
    on<HelperTaskDateEvent>((event, emit) async => emit(HelperTaskDateState(deadline: event.deadline, start_date: event.start_date)));
    on<HelperLeadContactEvent>((event, emit) async => emit(HelperLeadContactState(id: event.id, name: event.name)));
    on<HelperCompanyContactEvent>((event, emit) async => emit(HelperCompanyContactState(contact: event.contact)));
    on<HelperProjectMainEvent>((event, emit) async => emit(HelperProjectMainState(type: event.type, id: event.id, name: event.name)));
  }

}