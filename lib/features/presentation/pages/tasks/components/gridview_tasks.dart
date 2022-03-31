import 'package:avlo/core/models/tasks_model.dart';
import 'package:avlo/features/presentation/pages/tasks/components/tasks_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class GridViewTasks extends StatelessWidget {
  const GridViewTasks({
    Key? key,
    required this.tasks,
    this.isSearch = false,
  }) : super(key: key);

  final List<TasksModel> tasks;
  final bool isSearch;

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
                status: tasks[index].taskStatus!,
                task: tasks[index],
              ),
              feedback: Material(
                type: MaterialType.card,
                child: SizedBox(
                  height: _size.height * 0.22,
                  width: _size.width * 0.45,
                  child: TasksCard(
                    status: tasks[index].taskStatus!,
                    task: tasks[index],
                  ),
                ),
              ),
              child: TasksCard(
                status: tasks[index].taskStatus!,
                task: tasks[index],
              ),
            ),
          );

        },
      );
    }else {
      return Visibility(
        visible: !isSearch,
        child: Center(
          child: LocaleText('empty'),
        ),
      );
    }


  }
}
