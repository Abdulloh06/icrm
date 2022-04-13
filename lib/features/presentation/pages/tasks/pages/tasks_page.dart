/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/tasks_status_model.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/pages/tasks/components/tasks_card.dart';
import 'package:icrm/features/presentation/pages/tasks/pages/selected_tasks.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:icrm/widgets/main_app_bar.dart';
import 'package:icrm/widgets/main_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../../core/models/tasks_model.dart';
import '../../../../../widgets/main_button.dart';
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
  List<TaskStatusModel> tasksStatuses = [];

  final _controller = RefreshController();

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
                tasksStatuses = state.tasksStatuses;
              }
              return SmartRefresher(
                controller: _controller,
                enablePullUp: tasks.length > 15 ? !TasksGetNextPageEvent.hasReachedMax : false,
                onRefresh: () {
                  context.read<TasksBloc>().add(TasksInitEvent());
                  _controller.refreshCompleted();
                },
                onLoading: () {
                  context.read<TasksBloc>().add(TasksGetNextPageEvent(list: tasks));
                  _controller.loadComplete();
                  setState(() {});
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
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.mainColor,
                      ),
                    );
                  },
                ),
                child: Container(
                  child: DefaultTabController(
                    length: tasksStatuses.length,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LocaleText(
                                  'task_status_name',
                                  style: AppTextStyles.mainGrey,
                                ),
                                InkWell(
                                  radius: 2,
                                  borderRadius: BorderRadius.circular(20),
                                  child: SvgPicture.asset(
                                      'assets/icons_svg/edit.svg'),
                                  onTap: () =>
                                      setState(() {
                                        isEdit = !isEdit;
                                      }),
                                ),
                              ],
                            ),
                          const SizedBox(height: 20),
                          Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 53,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: MainTabBar(
                                            isScrollable: tasksStatuses.length >= 4,
                                            labelPadding: tasksStatuses.length >= 4 ? const EdgeInsets.symmetric(horizontal: 12) : const EdgeInsets.all(0),
                                            shadow: [
                                              BoxShadow(
                                                blurRadius: 4,
                                                color: Color.fromARGB(40, 0, 0, 0),
                                              ),
                                            ],
                                            tabs: List.generate(
                                                tasksStatuses.length,
                                                    (index) {
                                                  return GestureDetector(
                                                    onLongPress: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return SimpleDialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .circular(20)),
                                                            insetPadding: const EdgeInsets
                                                                .symmetric(),
                                                            title: Text(
                                                              Locales.string(
                                                                context,
                                                                'you_want_delete_tab',
                                                              ),
                                                              textAlign: TextAlign
                                                                  .center,
                                                              style: AppTextStyles
                                                                  .mainBold
                                                                  .copyWith(
                                                                  fontSize: 22),
                                                            ),
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                                children: [
                                                                  MainButton(
                                                                    color: AppColors.red,
                                                                    title: 'no',
                                                                    onTap: () => Navigator.pop(context),
                                                                    fontSize: 22,
                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal: 50,
                                                                      vertical: 10,
                                                                    ),
                                                                  ),
                                                                  MainButton(
                                                                    onTap: () {
                                                                      context.read<TasksBloc>().add(
                                                                        TasksStatusDeleteEvent(tasksStatuses[index].id),
                                                                      );
                                                                      Navigator.pop(context);
                                                                    },
                                                                    color: AppColors
                                                                        .mainColor,
                                                                    title: 'yes',
                                                                    fontSize: 22,
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal: 50,
                                                                        vertical: 10),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: DragTarget<TasksCard>(
                                                      onAccept: (object) {
                                                        if (object.task.taskStatusId != tasksStatuses[index].id) {
                                                          context.read<TasksBloc>().add(TasksUpdateEvent(
                                                            name: object.task.name,
                                                            deadline: object.task.deadline,
                                                            status: tasksStatuses[index].id,
                                                            description: object.task.description,
                                                            id: object.task.id,
                                                            parent_id: object.task
                                                                .parentId,
                                                            taskType: object.task
                                                                .taskType
                                                                .split('\\')
                                                                .last,
                                                            taskId: object.task
                                                                .taskId,
                                                            priority: object.task
                                                                .priority,
                                                            start_date: object.task
                                                                .startDate,
                                                          ));
                                                        }
                                                      },
                                                      builder: (context, accept,
                                                          reject) {
                                                        String title = tasksStatuses[index].name;

                                                        return Visibility(
                                                          replacement: Container(
                                                            width: 70,
                                                            child: TextFormField(
                                                              textAlign: TextAlign
                                                                  .center,
                                                              decoration: InputDecoration(
                                                                border: InputBorder
                                                                    .none,
                                                                isDense: true,
                                                              ),
                                                              initialValue: tasksStatuses[index]
                                                                  .name,
                                                              onChanged: (value) {
                                                                title = value;
                                                              },
                                                              onEditingComplete: () {
                                                                print("Complete");
                                                                context.read<TasksBloc>().add(
                                                                  TasksStatusUpdateEvent(
                                                                    name: title,
                                                                    id: tasksStatuses[index].id,
                                                                  ),
                                                                );
                                                                setState(() {
                                                                  isEdit != isEdit;
                                                                });
                                                              },
                                                              onSaved: (value) {
                                                                print("Saved");
                                                              },
                                                              onFieldSubmitted: (value) {
                                                                print("Field");
                                                              },
                                                            ),
                                                          ),
                                                          visible: !isEdit,
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              title,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),
                                        Visibility(
                                          visible: isEdit,
                                          child: GestureDetector(
                                            onTap: () {
                                              String title = '';
                                              showDialog(context: context,
                                                builder: (context) {
                                                return AlertDialog(
                                                      title: TextField(
                                                        decoration: InputDecoration(
                                                          enabledBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                              width: 1,
                                                              color: AppColors.greyLight,
                                                            ),
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                width: 1.5,
                                                                color: AppColors
                                                                    .mainColor),
                                                            borderRadius: BorderRadius
                                                                .circular(10),
                                                          ),
                                                        ),
                                                        onChanged: (value) {
                                                          title = value;
                                                        },
                                                      ),
                                                      actions: [
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              MainButton(
                                                                onTap: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal: 20,
                                                                    vertical: 15),
                                                                color: AppColors.red,
                                                                title: 'cancel',
                                                              ),
                                                              MainButton(
                                                                onTap: () {
                                                                  if (title != '') {
                                                                    context.read<TasksBloc>().add(
                                                                      TasksStatusAddEvent(name: title),
                                                                    );
                                                                    Navigator.pop(context);
                                                                    isEdit = !isEdit;
                                                                  }
                                                                },
                                                                color: AppColors.green,
                                                                title: 'save',
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                },
                                              );
                                            },
                                            child: SvgPicture.asset(
                                              'assets/icons_svg/add_icon.svg',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Expanded(
                                    child: Builder(
                                        builder: (context) {
                                          return TabBarView(
                                            children: List.generate(tasksStatuses.length, (index) {
                                              List<TasksModel> list = tasks.where((element) =>
                                              element.taskStatus!.id ==
                                                  tasksStatuses[index].id &&
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
                                                                status: list[index].taskStatus!,
                                                                task: list[index],
                                                              ),
                                                              feedback: SizedBox(
                                                                height: 120,
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width / 3,
                                                                child: Material(
                                                                  child: TasksCard(
                                                                    isDragging: true,
                                                                    onTap: () {},
                                                                    status: list[index].taskStatus!,
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
                                                                        taskStatuses: tasksStatuses,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                status: list[index]
                                                                    .taskStatus!,
                                                                task: list[index],
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      }
                                                    } else {
                                                      return Center(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Image.asset(
                                                                'assets/png/empty.png'),
                                                            LocaleText(
                                                                "unfortunately_nothing_yet"),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  }
                                              );
                                            }),
                                          );
                                        }
                                    ),
                                  ),
                                ],
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
