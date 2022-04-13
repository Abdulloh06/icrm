/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/tasks_model.dart';
import 'package:icrm/core/models/tasks_status_model.dart';
import 'package:icrm/core/models/team_model.dart';
import 'package:icrm/features/presentation/blocs/tasks_bloc/tasks_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../../core/repository/user_token.dart';
import '../../../../../core/util/colors.dart';
import '../../../../../core/util/text_styles.dart';
import '../../../../../widgets/circular_progress_bar.dart';
import '../../../../../widgets/update_members.dart';
import '../pages/calendar.dart';
import '../pages/create_task.dart';

//ignore:must_be_immutable
class MainTaskInfo extends StatelessWidget {
  MainTaskInfo({
    Key? key,
    required this.task,
    required this.taskStatuses,
  }) : super(key: key);
  late TasksModel task;
  late List<TaskStatusModel> taskStatuses;

  static String start_date = '';
  static String deadline = '';

  void initState() {
    try {
      start_date =
          DateFormat("dd.MM.yyyy").format(DateTime.parse(task.startDate));
      deadline = DateFormat("dd.MM.yyyy").format(DateTime.parse(task.deadline));
    } catch (error) {
      print(error);
      start_date = task.startDate;
      deadline = task.deadline;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TeamModel> assigns = task.members ?? [];
    initState();
    return Container(
      decoration: BoxDecoration(
        color: UserToken.isDark ? AppColors.mainDark : Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.only(top: 23, right: 20, left: 20, bottom: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  task.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headerTask,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    child: SvgPicture.asset('assets/icons_svg/delete.svg'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateTask(
                            fromEdit: true,
                            task: task,
                          ),
                        ),
                      );
                    },
                  ),
                  GestureDetector(
                    child: SvgPicture.asset('assets/icons_svg/edit.svg'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateTask(
                            fromEdit: true,
                            task: task,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            task.description,
            style: AppTextStyles.descriptionGrey,
          ),
          SizedBox(height: 14),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return TasksCalendar(
                        task: task,
                      );
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  decoration: BoxDecoration(
                    color: UserToken.isDark
                        ? AppColors.cardColorDark
                        : Color.fromARGB(255, 245, 245, 250),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SvgPicture.asset(
                        'assets/icons_svg/calendar_bg.svg',
                      ),
                      SizedBox(width: 8),
                      Text(
                        start_date + " - " + deadline,
                        style: AppTextStyles.descriptionGrey,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 36),
              Builder(
                builder: (context) {
                  if (taskStatuses.indexWhere(
                          (element) => element.id == task.taskStatusId) ==
                      0) {
                    return CircularProgressBar(percent: 5);
                  } else if (task.taskStatusId == taskStatuses.last.id) {
                    return CircularProgressBar(percent: 100);
                  } else {
                    return CircularProgressBar(
                        percent: 95 /
                            (taskStatuses.length - 1) *
                            (taskStatuses.indexWhere(
                                (element) => element.id == task.taskStatusId)));
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 14),
          LocaleText(
            'team',
            style: AppTextStyles.mainTextFont.copyWith(
              color: UserToken.isDark ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.065,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        width: assigns.length != 1 ? 108 : 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: assigns.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onLongPress: () {
                                context.read<TasksBloc>().add(TasksDeleteUserEvent(user: assigns[index].id, task_id: task.id));
                              },
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: assigns[index].social_avatar,
                                  errorWidget: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/png/no_user.png',
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              List<int> assigns = [];
                              for (int i = 0; i < task.members!.length; i++) {
                                assigns.add(task.members![i].id);
                              }

                              return UpdateMembers(
                                task_id: task.id,
                                assigns: assigns,
                              );
                            },
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/icons_svg/add_icon.svg',
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  elevation: 0,
                  color: Colors.transparent,
                  itemBuilder: (context) {
                    return List.generate(taskStatuses.length, (index) {
                      return PopupMenuItem(
                        onTap: () {
                          context.read<TasksBloc>().add(
                                TasksUpdateEvent(
                                  id: task.id,
                                  name: task.name,
                                  start_date: task.startDate,
                                  deadline: task.deadline,
                                  priority: task.priority,
                                  description: task.description,
                                  status: taskStatuses[index].id,
                                  parent_id: null,
                                  taskType: task.taskType,
                                  taskId: task.taskId,
                                ),
                              );
                        },
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(int.parse(taskStatuses[index]
                                .color
                                .split('#')
                                .join('0xff'))),
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          child: Text(
                            taskStatuses[index].name,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(int.parse(
                          task.taskStatus!.color.split('#').join('0xff'))),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      task.taskStatus!.name,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
