/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/blocs/notes_bloc/notes_bloc.dart';
import 'package:icrm/features/presentation/blocs/notes_bloc/notes_event.dart';
import 'package:icrm/features/presentation/blocs/notes_bloc/notes_state.dart';
import 'package:icrm/features/presentation/pages/drawer/create_note/create_note.dart';
import 'package:icrm/features/presentation/pages/profile/components/notes_card.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

class Notes extends StatelessWidget {
  const Notes({Key? key, required this.search}) : super(key: key);

  final String search;

  @override
  Widget build(BuildContext context) {
    context.read<NotesBloc>().add(NotesInitEvent());

    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        if(state is NotesInitState && state.notes.isNotEmpty) {
          return MasonryGridView.builder(
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            itemCount: state.notes.length,
            itemBuilder: (context, index) {
              String date;
              try {
                date = DateFormat('dd-mm-yyyy').format(DateTime.parse(state.notes[index].created_at));
              } catch(_) {
                date = state.notes[index].created_at;
              }
              return Visibility(
                visible: state.notes[index].title.toLowerCase().contains(search.toLowerCase()),
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNote(
                    isSubNote: true,
                    title: state.notes[index].title,
                    description: state.notes[index].content,
                    id: state.notes[index].id,
                  ))),
                  child: NotesCard(
                    note: state.notes[index],
                    shareTap: () {
                      Share.share(
                        state.notes[index].title + "\n" + state.notes[index].content,
                      );
                    },
                    deleteTap: () => context.read<NotesBloc>().add(NotesDeleteEvent(state.notes[index].id)),
                    title: state.notes[index].title,
                    date: date,
                    description: state.notes[index].content,
                  ),
                ),
              );
            },
          );
        } else if(state is NotesInitState && state.notes.isEmpty) {
          return Center(
            child: LocaleText('empty', style: AppTextStyles.mainGrey),
          );
        } else {
          return Loading();
        }
      }
    );
  }
}
