/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:icrm/core/models/team_model.dart';
import 'package:icrm/core/service/api/get_team.dart';
import 'package:icrm/core/service/api/get_users.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/features/presentation/blocs/team_bloc/team_event.dart';
import 'package:icrm/features/presentation/blocs/team_bloc/team_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/service/api/get_team.dart';


class TeamBloc extends Bloc<TeamEvent, TeamState>{
  TeamBloc(TeamState initialState) : super(initialState) {
    on<TeamInitEvent>((event, emit) => _init(event: event, emit: emit));
    on<TeamAddEvent>((event, emit) => _add(event: event, emit: emit));
    on<TeamInviteEvent>((event, emit) => _invite(event: event, emit: emit));
    on<TeamUpdateEvent>((event, emit) => _update(event: event, emit: emit));
  }

  Future<void> _init({
    required TeamInitEvent event,
    required Emitter<TeamState> emit,
  }) async {
    emit(TeamLoadingState());

    try {
      List<TeamModel> team = await getIt.get<GetTeam>().getTeam();

      emit(TeamInitState(team: team));

    } catch(error) {
      print(error);
      emit(TeamErrorState(error: error.toString()));
    }
  }

  Future<void> _add({
    required TeamAddEvent event,
    required Emitter<TeamState> emit,
  }) async {
    emit(TeamLoadingState());

    try {

      bool result = await getIt.get<GetTeam>().addTeamMember(id: event.id);

      if(result) {
        List<TeamModel> team = await getIt.get<GetTeam>().getTeam();

        emit(TeamInitState(team: team));
      }else {
        emit(TeamErrorState(error: 'something_went_wrong'));
      }

    } catch(error) {
      print(error);

      emit(TeamErrorState(error: error.toString()));
    }
  }

  Future<void> _invite({
    required TeamInviteEvent event,
    required Emitter<TeamState> emit,
  }) async {
    emit(TeamLoadingState());

    try {

      bool result = await getIt.get<GetUsers>().sendInvitation(
        via: event.via,
        model_type: event.model_type,
        model_id: event.model_id,
      );

      if(result) {
        List<TeamModel> team = await getIt.get<GetTeam>().getTeam();

        emit(TeamInitState(team: team));
      }else {
        emit(TeamErrorState(error: 'something_went_wrong'));
      }

    } catch(error) {
      print(error);
      emit(TeamErrorState(error: 'something_went_wrong'));
    }

  }

  Future<void> _update({
    required TeamUpdateEvent event,
    required Emitter<TeamState> emit,
  }) async {
    emit(TeamLoadingState());

    try {

      final bool result = await getIt.get<GetTeam>().updateTeam(
        team: event.team,
        isOften: event.isOften,
      );

      if(result) {
        List<TeamModel> team = await getIt.get<GetTeam>().getTeam();

        emit(TeamInitState(team: team));
      }else {
        emit(TeamErrorState(error: 'something_went_wrong'));
      }

    } catch(e) {
      print(e);
      emit(TeamErrorState(error: 'something_went_wrong'));
    }

  }

}
