/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/tasks_model.dart';
import 'package:icrm/features/presentation/pages/tasks/components/tasks_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';


class ArchiveTasks extends StatelessWidget {
  const ArchiveTasks({
    Key? key,
    required this.tasks,
    required this.search,
  }) : super(key: key);

  final List<TasksModel> tasks;
  final String search;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if(tasks.isNotEmpty) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.05,
            ),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return Visibility(
                visible: tasks[index].name.toLowerCase().contains(search.toLowerCase()),
                child: TasksCard(
                  task: tasks[index],
                  onTap: () {},
                ),
              );
            },
          );
        }else {
          return Center(
            child: LocaleText("empty"),
          );
        }
      },
    );
  }
}
