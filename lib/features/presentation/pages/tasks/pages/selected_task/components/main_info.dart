/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/status_model.dart';
import 'package:icrm/core/models/tasks_model.dart';
import 'package:icrm/core/models/team_model.dart';
import 'package:icrm/features/presentation/blocs/tasks_bloc/tasks_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../../../../core/repository/user_token.dart';
import '../../../../../../../core/util/colors.dart';
import '../../../../../../../core/util/text_styles.dart';
import '../../../../../../../widgets/circular_progress_bar.dart';
import '../../../../../../../widgets/update_members.dart';
import '../../calendar.dart';
import '../../create_task.dart';

//ignore:must_be_immutable
class MainTaskInfo extends StatefulWidget {
  MainTaskInfo({
    Key? key,
    required this.task,
    required this.taskStatuses,
  }) : super(key: key);
  late TasksModel task;
  late List<StatusModel> taskStatuses;

  static String start_date = '';
  static String deadline = '';

  @override
  State<MainTaskInfo> createState() => _MainTaskInfoState();
}

class _MainTaskInfoState extends State<MainTaskInfo> {

  late int taskStatusId;

  @override
  void initState() {
    super.initState();
    taskStatusId = widget.task.taskStatusId;

    try {
      MainTaskInfo.start_date =
          DateFormat("dd.MM.yyyy").format(DateTime.parse(widget.task.startDate));
      if(widget.task.deadline.isNotEmpty) {
        MainTaskInfo.deadline = DateFormat("dd.MM.yyyy").format(DateTime.parse(widget.task.deadline));
      }else {
        MainTaskInfo.deadline = '';
      }
    } catch (error) {
      print(error);
      MainTaskInfo.start_date = widget.task.startDate;
      MainTaskInfo.deadline = widget.task.deadline;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TeamModel> assigns = widget.task.members ?? [];

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
                  widget.task.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headerTask,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 4),
                    child: GestureDetector(
                      child: SvgPicture.asset(
                        'assets/icons_svg/delete_circle.svg',
                        height: 36,
                      ),
                      onTap: () {
                        context.read<TasksBloc>().add(TasksDeleteEvent(id: widget.task.id));
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  GestureDetector(
                    child: SvgPicture.asset(
                      'assets/icons_svg/edit.svg',
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateTask(
                            fromEdit: true,
                            task: widget.task,
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
            widget.task.description,
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
                        task: widget.task,
                      );
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
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
                        MainTaskInfo.start_date + " - " + MainTaskInfo.deadline,
                        style: AppTextStyles.descriptionGrey,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 36),
              Builder(
                builder: (context) {
                  try {
                    if (widget.taskStatuses.indexWhere((element) => element.id == taskStatusId) == 0) {
                      return CircularProgressBar(percent: 5);
                    } else if (taskStatusId == widget.taskStatuses.last.id) {
                      return CircularProgressBar(percent: 100);
                    } else {
                      return CircularProgressBar(
                        percent: 95 / (widget.taskStatuses.length - 1) *
                            (widget.taskStatuses.indexWhere(
                                    (element) => element.id == taskStatusId)),
                      );
                    }
                  } catch(_) {
                    return CircularProgressBar(percent: 20);
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
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        width: assigns.length > 1 ? 108 : assigns.isEmpty ? 0 : 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: assigns.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onLongPress: () {
                                context.read<TasksBloc>().add(TasksDeleteUserEvent(user: assigns[index].id, task_id: widget.task.id));
                              },
                              child: Container(
                                width: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.grey,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: assigns[index].social_avatar,
                                    fit: BoxFit.fill,
                                    errorWidget: (context, error, stackTrace) {
                                      String name = assigns[index].first_name[0];
                                      String surname = "";
                                      if(assigns[index].last_name.isNotEmpty) {
                                        surname = assigns[index].last_name[0];
                                      }
                                      return Center(
                                        child: Text(
                                          name + surname,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: UserToken.isDark
                                                ? Colors.white
                                                : Colors.grey.shade600,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              List<int> assigns = [];
                              for (int i = 0; i < widget.task.members!.length; i++) {
                                assigns.add(widget.task.members![i].id);
                              }

                              return UpdateMembers(
                                task_id: widget.task.id,
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
                    return List.generate(widget.taskStatuses.length, (index) {
                      return PopupMenuItem(
                        onTap: () {
                          setState(() {
                            taskStatusId = widget.taskStatuses[index].id;
                          });
                          context.read<TasksBloc>().add(
                            TasksUpdateEvent(
                              id: widget.task.id,
                              name: widget.task.name,
                              start_date: widget.task.startDate,
                              deadline: widget.task.deadline,
                              priority: widget.task.priority,
                              description: widget.task.description,
                              status: widget.taskStatuses[index].id,
                              parent_id: null,
                              taskType: widget.task.taskType,
                              taskId: widget.task.taskId,
                            ),
                          );
                        },
                        padding: EdgeInsets.only(right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(int.parse(widget.taskStatuses[index].userLabel!.color
                                .split('#')
                                .join('0xff'))),
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            horizontal: 25, vertical: 8,
                          ),
                          child: Text(
                            widget.taskStatuses[index].userLabel!.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    });
                  },
                  child: Builder(
                    builder: (context) {
                      try {
                        return Container(
                          padding:  EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                          decoration: BoxDecoration(
                            color: Color(int.parse(
                                widget.taskStatuses.elementAt(widget.taskStatuses.indexWhere((element) => element.id == taskStatusId)).userLabel!.color.split('#').join('0xff'))),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            widget.taskStatuses.elementAt(widget.taskStatuses.indexWhere((element) => element.id == taskStatusId)).userLabel!.name,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        );
                      } catch (_) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                          decoration: BoxDecoration(
                            color: Color(int.parse(
                                widget.task.taskStatus!.userLabel!.color.split('#').join('0xff'))),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            widget.task.taskStatus!.userLabel!.name,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
                    },
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
