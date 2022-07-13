/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:icrm/core/models/notes_model.dart';
import 'package:icrm/core/service/api/get_notes.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/features/presentation/blocs/notes_bloc/notes_event.dart';
import 'package:icrm/features/presentation/blocs/notes_bloc/notes_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState>{

  NotesBloc(NotesState initialState) : super(initialState) {
    on<NotesInitEvent>((event, emit) => _init(event: event, emit: emit));
    on<NotesAddEvent>((event, emit) => _addNotes(event: event, emit: emit));
    on<NotesUpdateEvent>((event, emit) => _updateNotes(event: event, emit: emit));
    on<NotesDeleteEvent>((event, emit) => _deleteNotes(event: event, emit: emit));
  }

  Future<void> _init({
    required NotesInitEvent event,
    required Emitter<NotesState> emit,
  }) async {
    try {
      List<NotesModel> notes = await getIt.get<GetNotes>().getNotes();
      emit(NotesInitState(notes: notes));
    } catch(e) {
      print(e);
      emit(NotesErrorState(error: 'something_went_wrong'));
    }
  }

  Future<void> _addNotes({
    required NotesAddEvent event,
    required Emitter<NotesState> emit,
  }) async {
    emit(NotesLoadingState());

    try {
      bool result = await getIt.get<GetNotes>().addNotes(
        title: event.title,
        content: event.content,
        images: event.images,
      );

      if(result) {

        List<NotesModel> notes = await getIt.get<GetNotes>().getNotes();

        emit(NotesInitState(notes: notes));
      }else {
        emit(NotesErrorState(error: 'something_went_wrong'));
      }
    }catch (e) {
      print(e);
      emit(NotesErrorState(error: e.toString()));
    }
  }

  Future<void> _updateNotes({
    required NotesUpdateEvent event,
    required Emitter<NotesState> emit,
  }) async {
    emit(NotesLoadingState());

    try {

      bool result = await getIt.get<GetNotes>().updateNotes(id: event.id, title: event.title, content: event.content);

      if(result) {
        List<NotesModel> notes = await getIt.get<GetNotes>().getNotes();
        emit(NotesInitState(notes: notes));
      }else {
        emit(NotesErrorState(error: 'something_went_wrong'));
      }

    } catch (error) {
      print(error);
      emit(NotesErrorState(error: error.toString()));
    }
  }

  Future<void> _deleteNotes({
    required NotesDeleteEvent event,
    required Emitter<NotesState> emit,
  }) async {
    emit(NotesLoadingState());

    try {

      bool result = await getIt.get<GetNotes>().deleteNotes(id: event.id);

      if(result) {
        List<NotesModel> notes = await getIt.get<GetNotes>().getNotes();
        emit(NotesInitState(notes: notes));
      }else {
        emit(NotesErrorState(error: 'something_went_wrong'));
      }

    } catch (error) {
      print(error);
      emit(NotesErrorState(error: error.toString()));
    }
  }

}