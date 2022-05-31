/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/tasks_model.dart';
import 'package:icrm/features/presentation/pages/tasks/components/tasks_card.dart';
import 'package:icrm/features/presentation/pages/tasks/pages/selected_task/selected_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class GridViewTasks extends StatelessWidget {
  const GridViewTasks({
    Key? key,
    required this.tasks,
    this.onTap,
  }) : super(key: key);

  final List<TasksModel> tasks;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    if(tasks.isNotEmpty) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
        ),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Container(
            child: LongPressDraggable<TasksCard>(
              data: TasksCard(
                onTap: () {},
                task: tasks[index],
              ),
              feedback: Material(
                type: MaterialType.card,
                child: SizedBox(
                  height: _size.height * 0.22,
                  width: _size.width * 0.45,
                  child: TasksCard(
                    onTap: () {},
                    task: tasks[index],
                  ),
                ),
              ),
              child: TasksCard(
                onTap: onTap != null ? onTap! : () => Navigator.push(context, MaterialPageRoute(builder: (context) => TaskPage(
                  task: tasks[index],
                  taskStatuses: [],
                ))),
                task: tasks[index],
              ),
            ),
          );

        },
      );
    }else {
      return Center(
        child: LocaleText('empty'),
      );
    }


  }
}
