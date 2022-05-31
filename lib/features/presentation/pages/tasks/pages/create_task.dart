/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/tasks_model.dart';
import 'package:icrm/core/models/team_model.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/blocs/helper_bloc/helper_bloc.dart';
import 'package:icrm/features/presentation/blocs/helper_bloc/helper_event.dart';
import 'package:icrm/features/presentation/blocs/helper_bloc/helper_state.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_event.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_state.dart';
import 'package:icrm/features/presentation/blocs/tasks_bloc/tasks_bloc.dart';
import 'package:icrm/features/presentation/pages/add_project/components/add_members.dart';
import 'package:icrm/features/presentation/pages/add_project/components/reminder_calendar.dart';
import 'package:icrm/features/presentation/pages/profile/pages/my_task_page.dart';
import 'package:icrm/features/presentation/pages/widgets/double_buttons.dart';
import 'package:icrm/widgets/custom_text_field.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../../core/models/status_model.dart';
import '../../../blocs/cubits/bottom_bar_cubit.dart';
import '../../main/main_page.dart';
import '../components/priority.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({
    Key? key,
    this.parent_id,
    this.task_id = 1,
    this.task_type = 'user',
    this.fromEdit = false,
    this.fromTask = true,
    this.task,
  }) : super(key: key);

  final int? parent_id;
  final String task_type;
  final int task_id;
  final bool fromEdit;
  final bool fromTask;
  final TasksModel? task;

  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _calendarController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String statusText = '';
  String priorityText = '';

  int? status;
  int priority = 9;
  int? project;
  String start_date = '';
  String deadline = '';
  List<TeamModel> members = [];
  List<TeamModel> projectMembers = [];
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
    if(priority == 9) {
      priorityText = Locales.string(context, "normal");
    }
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
            if(widget.task_type == 'lead') {
              Navigator.pop(context);
              context.read<HomeBloc>().add(HomeInitEvent());
              context.read<TasksBloc>().add(TasksInitEvent());
            }else {
              if (state.task.parentId == null) {
                if(project != null) {
                  context.read<BottomBarCubit>().changePage(3);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
                }else {
                  context.read<TasksBloc>().add(TasksInitEvent());
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyTasks()));
                }
              } else {
                context.read<TasksBloc>().add(TasksInitEvent());
                Navigator.pop(context);
              }
            }
          }
        }, builder: (context, state) {
          if (state is TasksLoadingState) {
            return Loading();
          } else {
            return ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
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
                            if(!members.any((element) => element.id == state.team.id)) {
                              members.add(state.team);
                            }
                            context.read<HelperBloc>().add(HelperInitEvent());
                          }
                          if (state is HelperTaskDateState) {
                            start_date = state.start_date;
                            deadline = state.deadline;

                            _calendarController.text =
                                start_date + " - " + deadline;
                            context.read<HelperBloc>().add(HelperInitEvent());
                          }
                        },
                        builder: (context, help) {
                          return Form(
                            key: _formKey,
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
                              Visibility(
                                visible: !widget.fromEdit && widget.fromTask,
                                child: Column(
                                  children: [
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
                                                          taskId = state.projects[index].id;
                                                          taskType = 'project';
                                                          projectMembers = state.projects[index].members ?? [];
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
                                  ],
                                ),
                              ),
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
                                                members: projectMembers,
                                              );
                                            },
                                          );
                                        },
                                        validator: (value) => null,
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
                                          return GestureDetector(
                                            onLongPress: () {
                                              members.removeAt(index);
                                              setState(() {});
                                            },
                                            child: Container(
                                              width: 55,
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: members[index].social_avatar,
                                                  fit: BoxFit.fill,
                                                  errorWidget: (context, error, bt) {
                                                    return Image.asset(
                                                      'assets/png/no_user.png',
                                                      fit: BoxFit.fill,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
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
                                validator: (value) => null,
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
                                    if(state is TasksInitState) {
                                      if(state.tasksStatuses.isNotEmpty && status == null) {
                                        List<StatusModel> visibleStatuses = state.tasksStatuses.where((element) => element.userLabel != null).toList();
                                        if(visibleStatuses.isNotEmpty) {
                                          status = visibleStatuses.first.id;
                                          statusText = visibleStatuses.first.userLabel!.name;
                                        }
                                      }
                                    }
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
                                      List<StatusModel> visibleStatuses = state.tasksStatuses.where((element) => element.userLabel != null).toList();
                                      return List.generate(
                                        visibleStatuses.length,
                                        (index) {
                                          String title = visibleStatuses[index].userLabel!.name;
                                          String color = visibleStatuses[index].userLabel!.color;
                                          return PopupMenuItem(
                                            onTap: () {
                                              setState(() {
                                                status = visibleStatuses[index].id;
                                                statusText = title;
                                              });
                                            },
                                            padding:
                                                const EdgeInsets.only(right: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Color(int.parse(color.split('#').join('0xff')),
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8,
                                              ),
                                              child: Text(
                                                title,
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
                                          statusText == '' ? Locales.string(context, 'status') : statusText,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: statusText == '' ? Colors.grey : UserToken.isDark ? Colors.white : Colors.black,
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          'assets/icons_svg/plus.svg',
                                        ),
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
                                      height: 40,
                                      child: Priority(
                                        text: 'urgent',
                                        textColor: AppColors.red,
                                        backgroundColor: AppColors.redLight,
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 2,
                                      height: 40,
                                      child: Priority(
                                        text: 'important',
                                        textColor: AppColors.mainColor,
                                        backgroundColor: Color(0xfffDFDAF4),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 9,
                                      height: 40,
                                      child: Priority(
                                        text: 'normal',
                                        textColor: AppColors.green,
                                        backgroundColor: AppColors.greenLight,
                                      ),
                                    ),
                                    PopupMenuItem(
                                      height: 40,
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
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        priorityText == '' ? Locales.string(context, 'priority') : priorityText,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: priorityText == '' ? Colors.grey : UserToken.isDark ? Colors.white : Colors.black,
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
                                validator: (value) => null,
                                onChanged: (value) {},
                              ),
                            ],
                          ));
                        },
                      ),
                      const SizedBox(height: 80),
                      DoubleButtons(
                        onCancel: () {
                          Navigator.pop(context);
                        },
                        onSave: () {
                          if(_formKey.currentState!.validate()) {
                            List<int> users = [];
                            for (int i = 0; i < members.length; i++) {
                              users.add(members[i].id);
                            }
                            if (widget.fromEdit) {
                              context.read<TasksBloc>().add(TasksUpdateEvent(
                                id: widget.task!.id,
                                parent_id: widget.task!.parentId,
                                priority: priority,
                                status: status!,
                                start_date: start_date.toString(),
                                deadline: deadline.toString(),
                                name: _nameController.text,
                                description: _descriptionController.text,
                                taskType: widget.task!.taskType,
                                taskId: widget.task!.taskId,
                              ));
                              Navigator.pop(context);
                            } else {
                              String endDate;
                              try {
                                endDate = DateFormat("dd.MM.yyyy").parse(deadline).toString();
                              } catch(_) {
                                endDate = deadline;
                              }
                              context.read<TasksBloc>().add(
                                TasksAddEvent(
                                  parent_id: widget.parent_id,
                                  priority: priority,
                                  status: status!,
                                  start_date: '',
                                  deadline: endDate,
                                  name: _nameController.text,
                                  description: _descriptionController.text,
                                  taskType: taskType,
                                  taskId: taskId!,
                                  user: users,
                                ),
                              );
                            }
                            if(widget.task_type == 'lead') {
                              context.read<HomeBloc>().add(HomeInitEvent());
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
