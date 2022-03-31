import 'package:avlo/core/models/tasks_model.dart';
import 'package:avlo/core/models/team_model.dart';
import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:avlo/core/util/text_styles.dart';
import 'package:avlo/features/presentation/blocs/helper_bloc/helper_bloc.dart';
import 'package:avlo/features/presentation/blocs/helper_bloc/helper_event.dart';
import 'package:avlo/features/presentation/blocs/helper_bloc/helper_state.dart';
import 'package:avlo/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:avlo/features/presentation/blocs/projects_bloc/projects_state.dart';
import 'package:avlo/features/presentation/blocs/tasks_bloc/tasks_bloc.dart';
import 'package:avlo/features/presentation/pages/add_project/components/add_members.dart';
import 'package:avlo/features/presentation/pages/add_project/components/reminder_calendar.dart';
import 'package:avlo/features/presentation/pages/tasks/pages/selected_tasks.dart';
import 'package:avlo/widgets/custom_text_field.dart';
import 'package:avlo/widgets/main_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../components/priority.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({
    Key? key,
    this.parent_id,
    this.task_id = 1,
    this.task_type = 'user',
    this.fromEdit = false,
    this.task,
  }) : super(key: key);

  final int? parent_id;
  final String task_type;
  final int task_id;
  final bool fromEdit;
  final TasksModel? task;

  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _calendarController = TextEditingController();

  static String statusText = '';
  static String priorityText = '';

  static int? status;
  static int? priority;
  static int? project;
  static String start_date = '';
  static String deadline = '';
  static List<TeamModel> members = [];
  String taskType = '';
  int? taskId;

  @override
  void initState() {
    super.initState();
    members.clear();
    taskId = widget.task_id;
    taskType = widget.task_type;

    if (widget.fromEdit) {
      _nameController.text = widget.task!.name;
      _descriptionController.text = widget.task!.description;
      _calendarController.text =
          widget.task!.startDate + ' - ' + widget.task!.deadline;

      statusText = widget.task!.taskStatus!.name;

      start_date = widget.task!.startDate;
      deadline = widget.task!.deadline;

      status = widget.task!.taskStatusId;
      priority = widget.task!.priority;
      members = widget.task!.members!;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fromEdit) {
      switch (widget.task!.priority) {
        case 1:
          priorityText = Locales.string(context, 'urgent');
          break;
        case 2:
          priorityText = Locales.string(context, 'important');
          break;
        case 9:
          priorityText = Locales.string(context, 'normal');
          break;
        case 10:
          priorityText = Locales.string(context, 'low');
          break;
      }
    }

    return Scaffold(
      backgroundColor: UserToken.isDark ? AppColors.mainDark : Colors.white,
      body: SafeArea(
        child: BlocConsumer<TasksBloc, TasksState>(listener: (context, state) {
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
          }

          if (state is TasksAddState) {
            if (state.task.parentId == null) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TaskPage(id: state.task.id)));
            } else {
              Navigator.pop(context);
            }
          }
          if(state is TasksUpdateState) {
            Navigator.pop(context);
          }
        }, builder: (context, state) {
          if (state is TasksLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocaleText(
                      'new_tasks',
                      style: AppTextStyles.headerTask,
                    ),
                    const SizedBox(height: 29),
                    BlocConsumer<HelperBloc, HelperState>(
                      listener: (context, state) {
                        if (state is HelperTaskMemberState) {
                          members.add(state.team);
                          context.read<HelperBloc>().add(HelperInitEvent());
                        }
                        if (state is HelperTaskDateState) {
                          start_date = state.start_date;
                          deadline = state.deadline;

                          _calendarController.text =
                              start_date + " - " + deadline;
                        }
                      },
                      builder: (context, help) {
                        return Form(
                            child: Column(
                          children: [
                            CustomTextField(
                              color: UserToken.isDark
                                  ? AppColors.textFieldColorDark
                                  : Colors.white,
                              isFilled: true,
                              hint: 'task_name',
                              controller: _nameController,
                              validator: (value) => value!.isEmpty
                                  ? Locales.string(
                                      context, 'must_fill_this_line')
                                  : null,
                              onChanged: (value) {},
                              onTap: () {},
                            ),
                            SizedBox(height: 15),
                            BlocBuilder<ProjectsBloc, ProjectsState>(
                              builder: (context, state) {
                                if(state is ProjectsInitState) {

                                  return SizedBox(
                                    height: 31,
                                    child: ScrollConfiguration(
                                      behavior: const ScrollBehavior().copyWith(overscroll: false),
                                      child: ListView.builder(
                                        itemCount: state.projects.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            borderRadius: BorderRadius.circular(15),
                                            onTap: () {
                                              setState(() {
                                                project = state.projects[index].id;
                                                taskId = project;
                                                taskType = 'project';
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(horizontal: 4),
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                border: Border.all(color: project == state.projects[index].id ? AppColors.mainColor : Color(0xffF5F6FB)),
                                                color: project == state.projects[index].id ? AppColors.mainColor : Colors.white,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  state.projects[index].name,
                                                  style: TextStyle(
                                                    color: project == state.projects[index].id ? Colors.white : Color(0xff737989),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        scrollDirection: Axis.horizontal,
                                      ),
                                    ),
                                  );
                                }else {
                                  return SizedBox.shrink();
                                }
                              }
                            ),
                            SizedBox(height: 15),
                            SizedBox(
                              height: 55,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AddMembers(
                                              id: 3,
                                            );
                                          },
                                        );
                                      },
                                      validator: (value) => members.isEmpty
                                          ? Locales.string(
                                              context, 'at_least_one_employee')
                                          : null,
                                      controller: TextEditingController(),
                                      suffixIcon: 'assets/icons_svg/add.svg',
                                      onChanged: (value) {},
                                      hint: 'appoint',
                                      readOnly: true,
                                      isFilled: true,
                                      color: UserToken.isDark
                                          ? AppColors.textFieldColorDark
                                          : Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: members.length,
                                      itemBuilder: (context, index) {
                                        return CachedNetworkImage(
                                          imageUrl:
                                              members[index].social_avatar,
                                          errorWidget: (context, error, bt) {
                                            return CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/png/no_user.png'),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              color: UserToken.isDark
                                  ? AppColors.textFieldColorDark
                                  : Colors.white,
                              isFilled: true,
                              iconMargin: 13,
                              suffixIcon: UserToken.isDark
                                  ? 'assets/icons_svg/calDark.svg'
                                  : 'assets/icons_svg/cal.svg',
                              readOnly: true,
                              hint: 'timing',
                              validator: (value) => value!.isEmpty
                                  ? Locales.string(
                                      context, 'must_fill_this_line')
                                  : null,
                              onChanged: (value) {},
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => ReminderCalendar(
                                    id: 3,
                                  ),
                                );
                              },
                              controller: _calendarController,
                            ),
                            const SizedBox(height: 15),
                            BlocBuilder<TasksBloc, TasksState>(
                                builder: (context, state) {
                              return PopupMenuButton(
                                offset: Offset(
                                  MediaQuery.of(context).size.width / 2,
                                  0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                                color: Colors.transparent,
                                itemBuilder: (BuildContext context) {
                                  if (state is TasksInitState &&
                                      state.tasksStatuses.isNotEmpty) {
                                    return List.generate(
                                      state.tasksStatuses.length,
                                      (index) {
                                        return PopupMenuItem(
                                          onTap: () {
                                            setState(() {
                                              status =
                                                  state.tasksStatuses[index].id;
                                              statusText = state
                                                  .tasksStatuses[index].name;
                                            });
                                          },
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Color(int.parse(state
                                                  .tasksStatuses[index].color
                                                  .split('#')
                                                  .join('0xff'))),
                                            ),
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            child: Text(
                                              state.tasksStatuses[index].name,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else if (state is TasksShowState) {
                                    return List.generate(
                                      state.taskStatuses.length,
                                      (index) {
                                        return PopupMenuItem(
                                          onTap: () {
                                            setState(() {
                                              status =
                                                  state.taskStatuses[index].id;
                                              statusText = state
                                                  .taskStatuses[index].name;
                                            });
                                          },
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Color(int.parse(state
                                                  .taskStatuses[index].color
                                                  .split('#')
                                                  .join('0xff'))),
                                            ),
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            child: Text(
                                              state.taskStatuses[index].name,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return [
                                      PopupMenuItem(
                                        child: LocaleText('empty'),
                                      ),
                                    ];
                                  }
                                },
                                child: Container(
                                  height: 48,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: UserToken.isDark
                                        ? AppColors.textFieldColorDark
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: AppColors.greyLight,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        status == null
                                            ? Locales.string(context, 'status')
                                            : statusText,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SvgPicture.asset(
                                          'assets/icons_svg/plus.svg'),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 15),
                            PopupMenuButton<int>(
                              onSelected: (index) {
                                setState(() {
                                  priority = index;
                                  switch (index) {
                                    case 1:
                                      priorityText =
                                          Locales.string(context, 'urgent');
                                      break;
                                    case 2:
                                      priorityText =
                                          Locales.string(context, 'important');
                                      break;
                                    case 9:
                                      priorityText =
                                          Locales.string(context, 'normal');
                                      break;
                                    case 10:
                                      priorityText =
                                          Locales.string(context, 'low');
                                      break;
                                  }
                                });
                              },
                              offset: Offset(
                                MediaQuery.of(context).size.width / 2,
                                0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                              color: Colors.transparent,
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem(
                                    value: 1,
                                    height: 30,
                                    child: Priority(
                                      text: 'urgent',
                                      textColor: AppColors.red,
                                      backgroundColor: AppColors.redLight,
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    height: 30,
                                    child: Priority(
                                      text: 'important',
                                      textColor: AppColors.mainColor,
                                      backgroundColor: Color(0xfffDFDAF4),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 9,
                                    height: 30,
                                    child: Priority(
                                      text: 'normal',
                                      textColor: AppColors.green,
                                      backgroundColor: AppColors.greenLight,
                                    ),
                                  ),
                                  PopupMenuItem(
                                    height: 30,
                                    value: 10,
                                    child: Priority(
                                      text: 'low',
                                      textColor: AppColors.greyDark,
                                      backgroundColor:
                                          AppColors.greyDark.withOpacity(0.1),
                                    ),
                                  ),
                                ];
                              },
                              child: Container(
                                height: 48,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: UserToken.isDark
                                      ? AppColors.textFieldColorDark
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 1,
                                    color: AppColors.greyLight,
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      priority == null
                                          ? Locales.string(context, 'priority')
                                          : priorityText,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SvgPicture.asset(
                                        'assets/icons_svg/plus.svg'),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              color: UserToken.isDark
                                  ? AppColors.textFieldColorDark
                                  : Colors.white,
                              isFilled: true,
                              controller: _descriptionController,
                              hint: 'description',
                              maxLines: 4,
                              validator: (value) => value!.isEmpty
                                  ? Locales.string(
                                      context, 'must_fill_this_line')
                                  : null,
                              onChanged: (value) {},
                              onTap: () {},
                            ),
                          ],
                        ));
                      },
                    ),
                    const SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MainButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 34, vertical: 12),
                          color: AppColors.red,
                          title: 'cancel',
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        MainButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 34, vertical: 12),
                          onTap: () {
                            List<int> users = [];
                            for (int i = 0; i < members.length; i++) {
                              users.add(members[i].id);
                            }

                            if (widget.fromEdit) {
                              context.read<TasksBloc>().add(TasksUpdateEvent(
                                    id: widget.task!.id,
                                    parent_id: widget.task!.parentId,
                                    priority: priority!,
                                    status: status!,
                                    start_date: start_date.toString(),
                                    deadline: deadline.toString(),
                                    name: _nameController.text,
                                    description: _descriptionController.text,
                                    taskType: widget.task!.taskType,
                                    taskId: widget.task!.taskId,
                                  ));
                            } else {
                              context.read<TasksBloc>().add(
                                TasksAddEvent(
                                  parent_id: widget.parent_id,
                                  priority: priority!,
                                  status: status!,
                                  start_date: DateFormat("dd.MM.yyyy").parse(start_date)
                                      .toString(),
                                  deadline: DateFormat("dd.MM.yyyy")
                                      .parse(deadline)
                                      .toString(),
                                  name: _nameController.text,
                                  description: _descriptionController.text,
                                  taskType: taskType,
                                  taskId: taskId!,
                                  user: users,
                                ),
                              );
                            }
                          },
                          color: AppColors.green,
                          title: 'create',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
