/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/status_model.dart';
import 'package:icrm/features/presentation/pages/tasks/components/task_tab.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:icrm/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import '../../../../../core/models/tasks_model.dart';
import '../../../../../core/util/colors.dart';
import '../../../../../core/util/text_styles.dart';
import '../../../blocs/tasks_bloc/tasks_bloc.dart';
import '../../tasks/components/tasks_card.dart';
import '../../tasks/pages/selected_task/selected_tasks.dart';

class MyTasks extends StatefulWidget {
  MyTasks({Key? key}) : super(key: key);

  @override
  State<MyTasks> createState() => _MyTasksState();
}

class _MyTasksState extends State<MyTasks> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 52),
        child: AppBarBack(
          title: 'my_tasks',
        ),
      ),
      body: BlocConsumer<TasksBloc, TasksState>(
        listener: (context, state) {
          if (state is TasksErrorState) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.all(20),
                backgroundColor: AppColors.mainColor,
                content: LocaleText(
                  state.error,
                  style: AppTextStyles.mainGrey.copyWith(color: Colors.white),
                ),
              ),
            );

            context.read<TasksBloc>().add(TasksInitEvent());
          }
        },
        builder: (context, state) {
          if (state is TasksInitState && state.tasksStatuses.isNotEmpty) {
            List<StatusModel> visibleStatuses = state.tasksStatuses
                .where((element) => element.userLabel != null)
                .toList();
            List<StatusModel> invisibleStatuses = state.tasksStatuses
                .where((element) => element.userLabel == null)
                .toList();

            return DefaultTabController(
              length: visibleStatuses.length,
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TaskTabBar(
                        visibleStatuses: visibleStatuses,
                        invisibleStatus: invisibleStatuses,
                      ),
                      const SizedBox(height: 15),
                      Expanded(
                        child: TabBarView(
                          children: List.generate(visibleStatuses.length, (index) {
                            List<TasksModel> tasks = state.tasks.where((element) =>
                                    element.taskStatus!.id ==
                                        visibleStatuses[index].id &&
                                    element.parentId == null &&
                                    element.taskType.split('\\').last.toLowerCase() == 'user')
                                .toList();

                            if (_searchController.text != '') {
                              tasks = state.tasks
                                  .where((element) =>
                                      element.taskStatus!.id ==
                                          visibleStatuses[index].id &&
                                      element.parentId == null &&
                                      element.name.toLowerCase().contains(
                                          _searchController.text.toLowerCase()))
                                  .toList();
                            }
                            return Builder(
                              builder: (context) {
                                if (tasks.isNotEmpty) {
                                  return GridView.builder(
                                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: 1.05,
                                      maxCrossAxisExtent:
                                          MediaQuery.of(context).size.width / 2,
                                    ),
                                    itemCount: tasks.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        child: LongPressDraggable<TasksCard>(
                                          data: TasksCard(
                                            onTap: () {},
                                            task: tasks[index],
                                          ),
                                          childWhenDragging: Container(),
                                          feedback: SizedBox(
                                            height: 120,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            child: Material(
                                              child: TasksCard(
                                                onTap: () {},
                                                isDragging: true,
                                                task: tasks[index],
                                              ),
                                            ),
                                          ),
                                          child: TasksCard(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TaskPage(
                                                            task: tasks[index],
                                                            taskStatuses:
                                                                visibleStatuses,
                                                          )));
                                            },
                                            task: tasks[index],
                                          ),
                                          dragAnchorStrategy:
                                              childDragAnchorStrategy,
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return Center(
                                    child: LocaleText('empty'),
                                  );
                                }
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}
