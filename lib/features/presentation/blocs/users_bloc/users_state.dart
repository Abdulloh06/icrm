import 'package:equatable/equatable.dart';
import '../../../../core/models/team_model.dart';

abstract class UsersState extends Equatable {}

class UsersInitState extends UsersState {
  final List<TeamModel> users;

  UsersInitState({required this.users});

  @override
  List<Object?> get props => [users];
}

class UsersLoadingState extends UsersState {
  @override
  List<Object?> get props => [];
}

class UsersErrorState extends UsersState {
  final String error;

  UsersErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}