import 'package:avlo/core/models/notes_model.dart';
import 'package:avlo/core/service/api/get_notes.dart';
import 'package:avlo/core/util/get_it.dart';
import 'package:avlo/features/presentation/blocs/notes_bloc/notes_event.dart';
import 'package:avlo/features/presentation/blocs/notes_bloc/notes_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState>{

  NotesBloc(NotesState initialState) : super(initialState) {
   on<NotesInitEvent>((event, emit) async{
     List<NotesModel> notes = await getIt.get<GetNotes>().getNotes();
     emit(NotesInitState(notes: notes));
   });

   on<NotesAddEvent>((event, emit) async {
     emit(NotesLoadingState());

     try {
       bool result = await getIt.get<GetNotes>().addNotes(title: event.title, content: event.content);

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
   });

   on<NotesUpdateEvent>((event, emit) async {

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

   });

   on<NotesDeleteEvent>((event, emit) async{

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
   });
  }

}