/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:equatable/equatable.dart';

abstract class UserCategoriesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserCategoriesInitEvent extends UserCategoriesEvent {}

class UserCategoriesAddEvent extends UserCategoriesEvent {
  final String name;

  UserCategoriesAddEvent({required this.name});

  @override
  List<Object?> get props => [name];
}

class UserCategoriesDeleteEvent extends UserCategoriesEvent {
  final int id;

  UserCategoriesDeleteEvent({required this.id});
  @override
  List<Object?> get props => [id];
}