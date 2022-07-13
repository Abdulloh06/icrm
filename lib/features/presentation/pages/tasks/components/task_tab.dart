import 'package:icrm/core/models/status_model.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_event.dart';
import 'package:icrm/features/presentation/pages/tasks/components/tasks_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/util/colors.dart';
import '../../../../../core/util/text_styles.dart';
import '../../../../../widgets/main_button.dart';
import '../../../../../widgets/main_tab_bar.dart';
import '../../../blocs/tasks_bloc/tasks_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskTabBar extends StatefulWidget {
  TaskTabBar({
    Key? key,
    required this.visibleStatuses,
    required this.invisibleStatus,
    this.fromProject = false,
  }) : super(key: key);

  final List<StatusModel> visibleStatuses;
  final List<StatusModel> invisibleStatus;
  final bool fromProject;

  @override
  State<TaskTabBar> createState() => _TaskTabBarState();
}

class _TaskTabBarState extends State<TaskTabBar> {
  
  bool isEdit = false;
  List<String> colors = [
    "0xff2fa1ed",
    "0xffe80914",
    "0xffed2fa4",
    "0xff2fedc7",
    "0xff1b1bf2",
    "0xffe8881a",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: LocaleText(
                'task_status_name',
                style: AppTextStyles.mainGrey,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            InkWell(
              radius: 2,
              borderRadius: BorderRadius.circular(20),
              child: SvgPicture.asset(
                  'assets/icons_svg/edit.svg'),
              onTap: () => setState(() {isEdit = !isEdit;}),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 53,
          child: Row(
            children: [
              Expanded(
                child: MainTabBar(
                  isScrollable: widget.visibleStatuses.length > 4,
                  labelPadding: widget.visibleStatuses.length > 4
                      ? const EdgeInsets.symmetric(horizontal: 12)
                      : const EdgeInsets.all(0),
                  shadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color.fromARGB(40, 0, 0, 0),
                    ),
                  ],
                  tabs: List.generate(
                      widget.visibleStatuses.length,
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
                                            context.read<TasksBloc>().add(TasksStatusDeleteEvent(widget.visibleStatuses[index].id));
                                            Navigator.pop(context);
                                          },
                                          color: AppColors.mainColor,
                                          title: 'yes',
                                          fontSize: 22,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 50,
                                            vertical: 10,
                                          ),
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
                              if (object.task.taskStatusId != widget.visibleStatuses[index].id) {
                                context.read<TasksBloc>().add(TasksUpdateEvent(
                                  name: object.task.name,
                                  deadline: object.task.deadline,
                                  status: widget.visibleStatuses[index].id,
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
                                if(widget.fromProject) {
                                  context.read<ProjectsBloc>().add(ProjectsInitEvent());
                                }
                              }
                            },
                            builder: (context, accept, reject) {
                              String title;
                              if(widget.visibleStatuses[index].userLabel != null) {
                                title = widget.visibleStatuses[index].userLabel!.name;
                              } else {
                                title = widget.visibleStatuses[index].name;
                              }

                              return Visibility(
                                replacement: Container(
                                  width: 70,
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                    initialValue: title,
                                    onChanged: (value) {
                                      title = value;
                                    },
                                    onEditingComplete: () {
                                      context.read<TasksBloc>().add(
                                        TasksStatusUpdateEvent(
                                          name: title,
                                          id: widget.visibleStatuses[index].id,
                                          color: widget.visibleStatuses[index].color,
                                        ),
                                      );
                                      isEdit = !isEdit;
                                      FocusScope.of(context).unfocus();
                                    },
                                  ),
                                ),
                                visible: !isEdit,
                                child: Container(
                                  alignment: Alignment.center,
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
                    String selectedColor = colors.first;
                    showDialog(context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          titlePadding: const EdgeInsets.all(20).copyWith(bottom: 5),
                          title: Column(
                            children: [
                              TextField(
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
                                      color: AppColors.mainColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onChanged: (value) {
                                  title = value;
                                },
                              ),
                              const SizedBox(height: 10),
                              StatefulBuilder(
                                builder: (context, setState) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: List.generate(colors.length, (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedColor = colors[index];
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(right: 2, left: 2),
                                          decoration: BoxDecoration(
                                            color: Color(int.parse(colors[index])),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              width: 2,
                                              color: selectedColor == colors[index] ? Colors.black : Colors.transparent,
                                            ),
                                          ),
                                          height: 40,
                                          width: 40,
                                        ),
                                      );
                                    }),
                                  );
                                }
                              ),
                            ],
                          ),
                          actions: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  MainButton(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                    color: AppColors.red,
                                    title: 'cancel',
                                  ),
                                  MainButton(
                                    onTap: () {
                                      if (title != '') {
                                        if(widget.invisibleStatus.isNotEmpty) {
                                          context.read<TasksBloc>().add(
                                            TasksStatusUpdateEvent(
                                              name: title,
                                              id: widget.invisibleStatus.first.id,
                                              color: selectedColor,
                                            ),
                                          );
                                          isEdit = !isEdit;
                                        }else {
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              behavior: SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              margin: const EdgeInsets.all(20),
                                              backgroundColor: AppColors.mainColor,
                                              content: LocaleText("max_statuses_added", style: AppTextStyles.mainGrey.copyWith(color: Colors.white)),
                                            ),
                                          );
                                        }
                                        Navigator.pop(context);
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
      ],
    );
  }
}
