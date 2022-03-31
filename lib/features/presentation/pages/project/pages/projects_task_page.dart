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
import '../../tasks/components/gridview_tasks.dart';
import '../../tasks/components/tasks_card.dart';

class ProjectsTaskPage extends StatefulWidget {
  const ProjectsTaskPage({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<ProjectsTaskPage> createState() => _ProjectsTaskPageState();
}

class _ProjectsTaskPageState extends State<ProjectsTaskPage> {

  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          if (state is TasksInitState &&
              state.tasksStatuses.isNotEmpty) {
            return DefaultTabController(
              length: state.tasksStatuses.length,
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Row(
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
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 53,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MainTabBar(
                                      isScrollable: state.tasksStatuses.length > 4,
                                      shadow: [
                                        BoxShadow(
                                          blurRadius: 4,
                                          color: Color.fromARGB(40, 0, 0, 0),
                                        ),
                                      ],
                                      tabs: List.generate(state.tasksStatuses.length,
                                              (index) {
                                            return GestureDetector(
                                              onLongPress: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return SimpleDialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(20)),
                                                      insetPadding: const EdgeInsets.symmetric(),
                                                      title: Text(
                                                        Locales.string(
                                                            context, 'you_want_delete_tab'),
                                                        textAlign: TextAlign.center,
                                                        style: AppTextStyles.mainBold
                                                            .copyWith(fontSize: 22),
                                                      ),
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.spaceAround,
                                                          children: [
                                                            MainButton(
                                                              color: AppColors.red,
                                                              title: 'no',
                                                              onTap: () => Navigator.pop(context),
                                                              fontSize: 22,
                                                              padding: const EdgeInsets.symmetric(
                                                                  horizontal: 50, vertical: 10),
                                                            ),
                                                            MainButton(
                                                              onTap: () {
                                                                context.read<TasksBloc>().add(TasksStatusDeleteEvent(state.tasksStatuses[index].id));
                                                                Navigator.pop(context);
                                                              },
                                                              color: AppColors.mainColor,
                                                              title: 'yes',
                                                              fontSize: 22,
                                                              padding: const EdgeInsets.symmetric(
                                                                  horizontal: 50, vertical: 10),
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
                                                  context.read<TasksBloc>().add(TasksUpdateEvent(
                                                    name: object.task.name,
                                                    deadline: object.task.deadline,
                                                    status: state.tasksStatuses[index].id,
                                                    description: object.task.description,
                                                    id: object.task.id,
                                                    parent_id: object.task.parentId,
                                                    taskType: 'user',
                                                    taskId: object.task.taskId,
                                                    priority: object.task.priority,
                                                    start_date: object.task.startDate,
                                                  ));
                                                },
                                                builder: (context, accept, reject) {
                                                  List<String> titles = [];
                                                  for(int i = 0; i < state.tasksStatuses.length; i++) {
                                                    titles.add(state.tasksStatuses[i].name);
                                                  }
                                                  return Visibility(
                                                    replacement: Tab(
                                                      child: TextFormField(
                                                        textAlign: TextAlign.center,
                                                        decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                        ),
                                                        initialValue: state.tasksStatuses[index].name,
                                                        onChanged: (value) {
                                                          titles[index] = value;
                                                        },
                                                        onEditingComplete: () {
                                                          context.read<TasksBloc>().add(TasksStatusUpdateEvent(
                                                            name: titles[index],
                                                            id: state.tasksStatuses[index].id,
                                                          ));
                                                        },
                                                      ),
                                                    ),
                                                    visible: !isEdit,
                                                    child: Tab(text: state.tasksStatuses[index].name),
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
                                        showDialog(context: context, builder: (context) {
                                          return AlertDialog(
                                            title: TextField(
                                              decoration: InputDecoration(
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(width: 1, color: AppColors.greyLight),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(width: 1.5, color: AppColors.mainColor),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                title = value;
                                              },
                                              onEditingComplete: () {
                                                context.read<TasksBloc>().add(TasksStatusAddEvent(name: title));
                                                Navigator.pop(context);
                                              },
                                            ),
                                          );
                                        });
                                      },
                                      child: SvgPicture.asset('assets/icons_svg/add_icon.svg',),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Expanded(
                              child: TabBarView(
                                children: List.generate(state.tasksStatuses.length, (index) {

                                  List<TasksModel> tasks = state.tasks.where((element) => element.taskStatus!.id == state.tasksStatuses[index].id && element.taskId == widget.id).toList();

                                  return GridViewTasks(tasks: tasks);
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
        });
  }
}
