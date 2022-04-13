/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/models/tasks_model.dart';
import '../../../../../core/util/colors.dart';
import '../../../../../core/util/text_styles.dart';
import '../../../../../widgets/main_button.dart';
import '../../../../../widgets/main_tab_bar.dart';
import '../../../blocs/tasks_bloc/tasks_bloc.dart';
import '../../tasks/components/tasks_card.dart';
import '../../tasks/pages/selected_tasks.dart';


class MyTasks extends StatefulWidget {
  MyTasks({Key? key}) : super(key: key);

  @override
  State<MyTasks> createState() => _MyTasksState();
}

class _MyTasksState extends State<MyTasks> {
  bool _canBuild = true;
  bool isEdit = false;
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
          buildWhen: (context, state) => _canBuild,
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
          builder: (context, state) {
            if (state is TasksInitState && state.tasksStatuses.isNotEmpty) {

              return DefaultTabController(
                length: state.tasksStatuses.length,
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
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
                              child: SvgPicture.asset('assets/icons_svg/edit.svg'),
                              onTap: () => setState(() {
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
                                        isScrollable: state.tasksStatuses.length >= 4,
                                        labelPadding: state.tasksStatuses.length >= 4 ? const EdgeInsets.symmetric(horizontal: 12) : const EdgeInsets.all(0),
                                        shadow: [
                                          BoxShadow(
                                            blurRadius: 4,
                                            color: Color.fromARGB(40, 0, 0, 0),
                                          ),
                                        ],
                                        tabs: List.generate(
                                            state.tasksStatuses.length,
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
                                                                    TasksStatusDeleteEvent(state.tasksStatuses[index].id),
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
                                                    if (object.task.taskStatusId != state.tasksStatuses[index].id) {
                                                      context.read<TasksBloc>().add(TasksUpdateEvent(
                                                        name: object.task.name,
                                                        deadline: object.task.deadline,
                                                        status: state.tasksStatuses[index].id,
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
                                                    String title = state.tasksStatuses[index].name;

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
                                                          initialValue: state.tasksStatuses[index]
                                                              .name,
                                                          onChanged: (value) {
                                                            title = value;
                                                          },
                                                          onEditingComplete: () {
                                                            print("Complete");
                                                            context.read<TasksBloc>().add(
                                                              TasksStatusUpdateEvent(
                                                                name: title,
                                                                id: state.tasksStatuses[index].id,
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
                                child: TabBarView(
                                  children: List.generate(state.tasksStatuses.length, (index) {

                                    List<TasksModel> tasks = state.tasks.where((element) => element.taskStatus!.id == state.tasksStatuses[index].id && element.parentId == null && element.taskType.split('\\').last.toLowerCase() == 'user').toList();

                                    if(_searchController.text != '') {
                                      tasks = state.tasks.where((element) => element.taskStatus!.id == state.tasksStatuses[index].id && element.parentId == null && element.name.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
                                    }
                                    return Builder(
                                      builder: (context) {
                                        if(tasks.isNotEmpty) {
                                          return GridView.builder(
                                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                              mainAxisSpacing: 10,
                                              crossAxisSpacing: 10,
                                              childAspectRatio: 1.05,
                                              maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
                                            ),
                                            itemCount: tasks.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                child: LongPressDraggable<TasksCard>(
                                                  data: TasksCard(
                                                    onTap: () {},
                                                    status: tasks[index].taskStatus!,
                                                    task: tasks[index],
                                                  ),
                                                  childWhenDragging: Container(),
                                                  feedback: SizedBox(
                                                    height: 120,
                                                    width: MediaQuery.of(context).size.width / 3,
                                                    child: Material(
                                                      child: TasksCard(
                                                        onTap: () {},
                                                        isDragging: true,
                                                        status: tasks[index].taskStatus!,
                                                        task: tasks[index],
                                                      ),
                                                    ),
                                                  ),
                                                  child: TasksCard(
                                                    onTap: () async {
                                                      _canBuild = false;
                                                      await Navigator.push(context, MaterialPageRoute(builder: (context) => TaskPage(
                                                        task: tasks[index],
                                                        taskStatuses: state.tasksStatuses,
                                                      )));
                                                      _canBuild = true;
                                                    },
                                                    status: tasks[index].taskStatus!,
                                                    task: tasks[index],
                                                  ),
                                                  dragAnchorStrategy: childDragAnchorStrategy,
                                                ),
                                              );

                                            },
                                          );
                                        }else {
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
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainColor,
                ),
              );
            }
          }),
    );
  }
}
