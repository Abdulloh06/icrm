/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:icrm/core/models/notes_model.dart';
import 'package:equatable/equatable.dart';

class NotesState extends Equatable{
  @override
  List<Object?> get props => [];
}

class NotesInitState extends NotesState {
  final List<NotesModel> notes;

  NotesInitState({required this.notes});

  @override
  List<Object?> get props => [notes];
}

class NotesLoadingState extends NotesState {}

class NotesErrorState extends NotesState {
  final String error;

  NotesErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
