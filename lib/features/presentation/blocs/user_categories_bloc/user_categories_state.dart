
import 'package:icrm/core/models/user_categories_model.dart';
import 'package:equatable/equatable.dart';

abstract class UserCategoriesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserCategoriesInitState extends UserCategoriesState {
  final List<UserCategoriesModel> list;

  UserCategoriesInitState({required this.list});

  @override
  List<Object?> get props => [list];
}

class UserCategoriesLoadingState extends UserCategoriesState {}

class UserCategoriesErrorState extends UserCategoriesState {
  final String error;

  UserCategoriesErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}