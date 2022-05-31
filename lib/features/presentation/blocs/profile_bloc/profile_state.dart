/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:icrm/core/models/profile_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitState extends ProfileState {
  final ProfileModel profile;

  ProfileInitState({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {}

class ProfileErrorState extends ProfileState {
  final String error;

  ProfileErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}