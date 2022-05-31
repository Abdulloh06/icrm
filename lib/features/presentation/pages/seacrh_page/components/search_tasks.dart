import 'package:icrm/core/models/status_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import '../../../../../core/models/tasks_model.dart';
import '../../tasks/components/tasks_card.dart';
import '../../tasks/pages/selected_task/selected_tasks.dart';

class SearchTasks extends StatelessWidget {
  const SearchTasks({
    Key? key,
    required this.search,
    required this.tasks,
    required this.taskStatuses,
  }) : super(key: key);

  final String search;
  final List<TasksModel> tasks;
  final List<StatusModel> taskStatuses;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if(tasks.isNotEmpty) {

          List<TasksModel> list = tasks.where((element) => element.name.toLowerCase().contains(search.toLowerCase())).toList();

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.005,
              maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return TasksCard(
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) => TaskPage(
                        task: list[index],
                        taskStatuses: taskStatuses,
                      ),
                    ),
                  );
                },
                task: list[index],
              );
            },
          );
        } else {
          return Center(
            child: LocaleText("empty"),
          );
        }
      },
    );
  }
}
