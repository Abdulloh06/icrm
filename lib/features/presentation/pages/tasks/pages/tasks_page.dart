import 'package:avlo/core/util/colors.dart';
import 'package:avlo/core/util/text_styles.dart';
import 'package:avlo/features/presentation/pages/tasks/components/gridview_tasks.dart';
import 'package:avlo/features/presentation/pages/tasks/components/tasks_card.dart';
import 'package:avlo/widgets/main_app_bar.dart';
import 'package:avlo/widgets/main_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 52),
        child: MainAppBar(scaffoldKey: widget.scaffoldKey, title: "tasks"),
      ),
      body: BlocConsumer<TasksBloc, TasksState>(
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
          if(state is TasksUpdateState) {
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
                                                        context, 'you_want_delete_tab',
                                                      ),
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

                                                String title = state.tasksStatuses[index].name;

                                                return Visibility(
                                                  replacement: Tab(
                                                    child: TextFormField(
                                                      textAlign: TextAlign.center,
                                                      decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                      ),
                                                      initialValue: state.tasksStatuses[index].name,
                                                      onChanged: (value) {
                                                        title = value;
                                                      },
                                                      onEditingComplete: () {
                                                        context.read<TasksBloc>().add(TasksStatusUpdateEvent(
                                                          name: title,
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
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                MainButton(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                                  color: AppColors.red,
                                                  title: 'cancel',
                                                ),
                                                MainButton(
                                                  onTap: () {
                                                    if(title != '') {
                                                      context.read<TasksBloc>().add(TasksStatusAddEvent(name: title));
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  color: AppColors.green,
                                                  title: 'save',
                                                ),
                                              ],
                                            ),
                                          ],
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

                                List<TasksModel> tasks = state.tasks.where((element) => element.taskStatus!.id == state.tasksStatuses[index].id && element.parentId == null).toList();

                                if(_searchController.text != '') {
                                  tasks = state.tasks.where((element) => element.taskStatus!.id == state.tasksStatuses[index].id && element.parentId == null && element.name.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
                                }
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
      }),
    );
  }
}
