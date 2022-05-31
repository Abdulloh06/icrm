/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/team_model.dart';
import 'package:icrm/core/service/api/get_users.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/features/presentation/blocs/users_bloc/users_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersInitEvent extends Equatable {

  final String search;

  UsersInitEvent({required this.search});

  @override
  List<Object?> get props => [search];
}

class UsersBloc extends Bloc<UsersInitEvent, UsersState>{
  UsersBloc(UsersState initialState) : super(initialState) {
    on<UsersInitEvent>((event, emit) async {

      try {

        final List<TeamModel> users = await getIt.get<GetUsers>().getUsers(search: event.search);

        emit(UsersInitState(users: users));
      } catch(error) {
        print(error);

        emit(UsersErrorState(error: error.toString()));

      }

    });
  }

}