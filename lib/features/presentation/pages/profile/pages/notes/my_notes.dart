/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/util/colors.dart';
import 'package:icrm/features/presentation/pages/drawer/create_note/create_note.dart';
import 'package:icrm/features/presentation/pages/profile/pages/notes/notes.dart';
import 'package:icrm/widgets/main_app_bar.dart';
import 'package:icrm/widgets/main_search_bar.dart';
import 'package:flutter/material.dart';

class MyNotes extends StatelessWidget {
  MyNotes({Key? key}) : super(key: key);

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 52),
        child: AppBarBack(title: 'notes'),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      children: [
                        MainSearchBar(
                          controller: _searchController,
                          onComplete: () {
                            FocusScope.of(context).unfocus();
                          },
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 20,),
                        Expanded(
                          child: Notes(
                            search: _searchController.text,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mainColor,
        child: Icon(Icons.add, size: 30, color: Colors.white,),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNote())),
      ),
    );
  }
}
