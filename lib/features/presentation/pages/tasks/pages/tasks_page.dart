/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/pages/tasks/components/task_tab.dart';
import 'package:icrm/features/presentation/pages/tasks/components/tasks_card.dart';
import 'package:icrm/features/presentation/pages/tasks/pages/selected_task/selected_tasks.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:icrm/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../../core/models/status_model.dart';
import '../../../../../core/models/tasks_model.dart';
import '../../../../../core/repository/user_token.dart';
import '../../../blocs/tasks_bloc/tasks_bloc.dart';

class NewTasks extends StatefulWidget {
  const NewTasks({Key? key, required this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _NewTasksState createState() => _NewTasksState();
}

class _NewTasksState extends State<NewTasks> {
  bool isEdit = false;
  
  List<TasksModel> tasks = [];
  List<StatusModel> visibleStatuses = [];
  List<StatusModel> invisibleStatus = [];

  final _controller = RefreshController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 52),
        child: MainAppBar(scaffoldKey: widget.scaffoldKey, title: "tasks"),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: BlocListener<TasksBloc, TasksState>(
          listener: (context, state) {
            if(state is TasksErrorState) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(20),
                  backgroundColor: AppColors.mainColor,
                  content: LocaleText(state.error, style: AppTextStyles.mainGrey.copyWith(color: Colors.white)),
                ),
              );
              context.read<TasksBloc>().add(TasksInitEvent());
            }
          },
          child: BlocBuilder<TasksBloc, TasksState>(
            builder: (context, state) {
              if(state is TasksInitState) {
                tasks = state.tasks;
                visibleStatuses = state.tasksStatuses.where((element) => element.userLabel != null).toList();
                invisibleStatus = state.tasksStatuses.where((element) => element.userLabel == null).toList();
              }
              return SmartRefresher(
                controller: _controller,
                enablePullUp: tasks.length > 14 ? !TasksGetNextPageEvent.hasReachedMax : false,
                onRefresh: () {
                  context.read<TasksBloc>().add(TasksInitEvent());
                  _controller.refreshCompleted();
                },
                onLoading: () {
                  context.read<TasksBloc>().add(TasksGetNextPageEvent(list: tasks));
                  _controller.loadComplete();
                },
                header: CustomHeader(
                  builder: (context, status) {
                    return Center(
                      child: RefreshProgressIndicator(
                        color: AppColors.mainColor,
                      ),
                    );
                  },
                ),
                footer: CustomFooter(
                  builder: (context, status) {
                    if(status == LoadStatus.loading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mainColor,
                        ),
                      );
                    }else {
                      return SizedBox.shrink();
                    }
                  },
                ),
                child: Container(
                  child: DefaultTabController(
                    length: visibleStatuses.length,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TaskTabBar(
                            visibleStatuses: visibleStatuses,
                            invisibleStatus: invisibleStatus,
                          ),
                          SizedBox(height: 15),
                          Expanded(
                            child: TabBarView(
                              children: List.generate(visibleStatuses.length, (index) {
                                List<TasksModel> list = tasks.where((element) =>
                                element.taskStatus!.id ==
                                    visibleStatuses[index].id &&
                                    element.parentId == null &&
                                    element.taskType.split('\\').last.toLowerCase() != 'user',
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
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/png/empty.png',
                                                color: UserToken.isDark ? Colors.white : Colors.black,
                                              ),
                                              LocaleText(
                                                "unfortunately_nothing_yet",
                                                style: TextStyle(
                                                  color: UserToken.isDark ? Colors.white : Colors.grey,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
