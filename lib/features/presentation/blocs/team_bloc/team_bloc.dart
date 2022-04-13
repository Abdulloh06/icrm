import 'package:icrm/core/models/team_model.dart';
import 'package:icrm/core/service/api/get_team.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/features/presentation/blocs/team_bloc/team_event.dart';
import 'package:icrm/features/presentation/blocs/team_bloc/team_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/service/api/get_team.dart';


class TeamBloc extends Bloc<TeamEvent, TeamState>{
  TeamBloc(TeamState initialState) : super(initialState) {
    on<TeamInitEvent>((event, emit) async {
      emit(TeamLoadingState());

      try {
        List<TeamModel> team = await getIt.get<GetTeam>().getTeam();

        emit(TeamInitState(team: team));

      } catch(error) {
        print(error);
        emit(TeamErrorState(error: error.toString()));
      }
    });

    on<TeamAddEvent>((event, emit) async {
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
    });
  }

}
