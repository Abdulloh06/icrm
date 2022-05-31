

import 'package:icrm/features/presentation/blocs/helper_bloc/helper_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'helper_event.dart';

class HelperBloc extends Bloc<HelperEvent, HelperState> {
  HelperBloc(HelperState initialState) : super(HelperLoadingState()) {

    on<HelperInitEvent>((event, emit) async => emit(HelperInitState()));

    on<HelperLeadMemberEvent>((event, emit) async {

      try {

        emit(HelperLeadMemberState(member: event.member));

      } catch(error) {
        print(error);

        emit(HelperErrorState(error: error.toString()));
      }

    });

    on<HelperProjectMemberEvent>((event, emit) async {
      try {

        emit(HelperProjectMemberState(member: event.member));

      } catch (error) {
        print(error);

        emit(HelperErrorState(error: error.toString()));
      }

    });

    on<HelperLeadDateEvent>((event, emit) async {

      try {

        emit(HelperLeadDateState(deadline: event.deadline, start_date: event.start_date));

      } catch(error) {
        print(error);

        emit(HelperErrorState(error: error.toString()));
      }
    });

    on<HelperProjectDateEvent>((event, emit) async {

      try {

        emit(HelperProjectDateState(deadline: event.deadline, start_date: event.start_date));

      } catch(error) {
        print(error);

        emit(HelperErrorState(error: error.toString()));
      }
    });


    on<HelperTaskMemberEvent>((event, emit) async {

      try {

        emit(HelperTaskMemberState(team: event.member));

      } catch(error) {
        print(error);

        emit(HelperErrorState(error: error.toString()));
      }
    });

    on<HelperTaskDateEvent>((event, emit) async {

      try {

        emit(HelperTaskDateState(deadline: event.deadline, start_date: event.start_date));

      } catch(error) {
        print(error);

        emit(HelperErrorState(error: error.toString()));
      }
    });

    on<HelperLeadContactEvent>((event, emit) async {

      try {

        emit(HelperLeadContactState(id: event.id, name: event.name));

      } catch(error) {
        print(error);
        emit(HelperErrorState(error: error.toString()));
      }

    });

    on<HelperCompanyContactEvent>((event, emit) async => emit(HelperCompanyContactState(contact: event.contact)));

  }

}