/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/status_model.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_state.dart';
import 'package:icrm/features/presentation/pages/tasks/components/task_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import '../../../../../core/models/tasks_model.dart';
import '../../../../../widgets/loading.dart';
import '../../../blocs/tasks_bloc/tasks_bloc.dart';
import '../../tasks/components/tasks_card.dart';
import '../../tasks/pages/selected_task/selected_tasks.dart';

class ProjectsTaskPage extends StatefulWidget {
  const ProjectsTaskPage({
    Key? key,
    required this.id,
    required this.tasks,
  }) : super(key: key);
  final int id;
  final List<TasksModel> tasks;

  @override
  State<ProjectsTaskPage> createState() => _ProjectsTaskPageState();
}

class _ProjectsTaskPageState extends State<ProjectsTaskPage> {

  late List<TasksModel> tasks;

  @override
  void initState() {
    super.initState();
    tasks = widget.tasks;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProjectsBloc, ProjectsState>(
      listener: (context, state) {
        if(state is ProjectsInitState) {
          tasks = state.projects.elementAt(
            state.projects.indexWhere((element) => element.id == widget.id),
          ).tasks ?? [];
          setState(() {});
        }
      },
      child: BlocBuilder<TasksBloc, TasksState>(
          builder: (context, state) {
            if (state is TasksInitState &&
                state.tasksStatuses.isNotEmpty) {
              List<StatusModel> visibleStatuses = state.tasksStatuses.where((element) => element.userLabel != null).toList();
              List<StatusModel> invisibleStatus = state.tasksStatuses.where((element) => element.userLabel == null).toList();

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
                          invisibleStatus: invisibleStatus,
                          fromProject: true,
                        ),
                        SizedBox(height: 15),
                        Expanded(
                          child: TabBarView(
                            children: List.generate(visibleStatuses.length, (index) {

                              List<TasksModel> list = tasks.where((element) =>
                              element.taskStatus!.id == visibleStatuses[index].id
                                  && element.taskId == widget.id
                              ).toList();

                              return Builder(
                                  builder: (context) {
                                    if (list.isNotEmpty) {
                                      if(state is TasksLoadingState) {
                                        return Loading();
                                      }else {
                                        return GridView.builder(
                                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                            mainAxisSpacing: 10,
                                            crossAxisSpacing: 10,
                                            childAspectRatio: 1.05,
                                            maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
                                          ),
                                          itemCount: list.length,
                                          itemBuilder: (context, index) {
                                            return LongPressDraggable<TasksCard>(
                                              childWhenDragging: Container(),
                                              data: TasksCard(
                                                onTap: () {},
                                                task: list[index],
                                              ),
                                              feedback: SizedBox(
                                                height: 120,
                                                width: MediaQuery.of(context).size.width / 3,
                                                child: Material(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: TasksCard(
                                                    isDragging: true,
                                                    onTap: () {},
                                                    task: list[index],
                                                  ),
                                                ),
                                              ),
                                              child: TasksCard(
                                                onTap: () {
                                                  Navigator.push(context,
                                                    MaterialPageRoute(
                                                      builder: (context) => TaskPage(
                                                        task: list[index],
                                                        taskStatuses: visibleStatuses,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                task: list[index],
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    } else {
                                      return Center(
                                        child: LocaleText("empty"),
                                      );
                                    }
                                  }
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
          }),
    );
  }
}
