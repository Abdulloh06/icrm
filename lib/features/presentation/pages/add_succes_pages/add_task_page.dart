/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/blocs/attachment_bloc/attachment_bloc.dart';
import 'package:icrm/features/presentation/blocs/show_bloc/show_bloc.dart';
import 'package:icrm/features/presentation/blocs/show_bloc/show_event.dart';
import 'package:icrm/features/presentation/blocs/show_bloc/show_state.dart';
import 'package:icrm/features/presentation/blocs/tasks_bloc/tasks_bloc.dart';
import 'package:icrm/features/presentation/pages/project/pages/project_document_page.dart';
import 'package:icrm/features/presentation/pages/tasks/components/main_info.dart';
import 'package:icrm/features/presentation/pages/tasks/pages/create_task.dart';
import 'package:icrm/widgets/main_app_bar.dart';
import 'package:icrm/widgets/main_bottom_bar.dart';
import 'package:icrm/widgets/main_tab_bar.dart';
import 'package:icrm/widgets/message_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/database/task_db.dart';
import '../../blocs/attachment_bloc/attachment_event.dart';
import '../tasks/components/priority.dart';
import '../tasks/components/subtasks_card.dart';

class AddTaskPage extends StatelessWidget {
  AddTaskPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  final _messageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    context.read<AttachmentBloc>().add(AttachmentShowEvent(content_type: 'task', content_id: id));
    context.read<ShowBloc>().add(ShowTaskEvent(id: id));

    return DefaultTabController(
      length: 3,
      child: BlocBuilder<ShowBloc, ShowState>(builder: (context, state) {

        if (state is ShowTaskState) {

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 52),
              child: AppBarBack(
                titleWidget: PopupMenuButton<int>(
                  onSelected: (index) {
                    context.read<TasksBloc>().add(
                      TasksUpdateEvent(
                        id: state.task.id,
                        name: state.task.name,
                        start_date: state.task.startDate,
                        deadline: state.task.deadline,
                        priority: index,
                        description: state.task.description,
                        status: state.task.taskStatusId,
                        parent_id: null,
                        taskType: state.task.taskType,
                        taskId: state.task.taskId,
                      ),
                    );
                  },
                  offset: Offset(
                    MediaQuery.of(context).size.width / 1,
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
                    height: 28,
                    width: 105,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: state.task.priority == 1
                          ? Color.fromARGB(255, 255, 223, 221)
                          : state.task.priority == 2
                          ? Color(0xffDFDAF4)
                          : state.task.priority == 9
                          ? Color.fromARGB(255, 223, 244, 228)
                          : AppColors.greyDark.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      state.task.priority == 1
                          ? Locales.string(context, 'urgent')
                          : state.task.priority == 2
                          ? Locales.string(context, 'important')
                          : state.task.priority == 9
                          ? Locales.string(context, 'normal')
                          : Locales.string(context, 'low'),
                      style: TextStyle(
                        fontSize: 10,
                        color: state.task.priority == 1
                            ? AppColors.red
                            : state.task.priority == 2
                            ? AppColors.mainColor
                            : state.task.priority == 9
                            ? AppColors.green
                            : AppColors.greyDark,
                      ),
                    ),
                  ),
                ),
                title: '',
              ),
            ),
            body: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MainTaskInfo(task: state.task, taskStatuses: state.taskStatuses),
                      SizedBox(height: 5),
                      SqliteApp(),
                      const SizedBox(height: 5),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                              child: SizedBox(
                                height: 52,
                                child: MainTabBar(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  shadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(40, 0, 0, 0),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                  tabs: [
                                    Tab(
                                      text:
                                      Locales.string(context, 'sub_task'),
                                    ),
                                    Tab(
                                      text: Locales.string(context, 'files'),
                                    ),
                                    Tab(
                                      text: Locales.string(context, 'chat'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20)
                                        .copyWith(top: 15),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => CreateTask(
                                                      parent_id: state.task.parentId,
                                                      task_type:
                                                      'user',
                                                      task_id: state.task.taskId,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  LocaleText(
                                                    'add',
                                                    style: AppTextStyles
                                                        .mainBold
                                                        .copyWith(
                                                      color: UserToken
                                                          .isDark
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  SvgPicture.asset(
                                                      'assets/icons_svg/add_yellow.svg'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Expanded(
                                          child: Builder(
                                              builder: (context) {
                                                if(state.task.subtasks!.isNotEmpty) {
                                                  return ListView.builder(
                                                    itemCount: state.task.subtasks!.length,
                                                    itemBuilder: (context, index) {
                                                      return Subtask(name: state.task.subtasks![index].name);
                                                    },
                                                  );
                                                }else {
                                                  return Center(
                                                    child: LocaleText('empty'),
                                                  );
                                                }
                                              }
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ProjectDocumentPage(
                                    project_id: state.task.id,
                                    content_type: 'task',
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.vertical(top: Radius.circular(10)),
                                        color: UserToken.isDark
                                            ? AppColors.mainDark
                                            : Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            color: AppColors.greyLight,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: state.task.comments.length,
                                              itemBuilder:
                                                  (context, index) {
                                                return GestureDetector(
                                                  onLongPress: () {
                                                  },
                                                  child: MessageCard(
                                                    parent_id: state.task.comments[index].parent_id,
                                                    job: UserToken.responsibility,
                                                    name: UserToken.name,
                                                    id: state.task.comments[index].id,
                                                    date: state.task.comments[index].created_at,
                                                    message: state.task.comments[index].content,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Container(
                                            height: 90,
                                            padding:
                                            const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: UserToken.isDark
                                                  ? AppColors.mainDark
                                                  : Colors.white,
                                              boxShadow: UserToken.isDark
                                                  ? []
                                                  : [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .shade400,
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5,),
                                              decoration: BoxDecoration(
                                                color: UserToken.isDark
                                                    ? AppColors.mainDark
                                                    : Color.fromRGBO(
                                                    241, 244, 247, 1),
                                                borderRadius:
                                                BorderRadius.circular(20),
                                              ),
                                              child: TextField(
                                                controller: _messageController,
                                                cursorColor:
                                                AppColors.mainColor,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  prefixIcon: Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        right: 10),
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                      Color.fromRGBO(
                                                          220,
                                                          223,
                                                          227,
                                                          1),
                                                      child: SvgPicture.asset(
                                                          'assets/icons_svg/clip.svg',
                                                          height: 25),
                                                    ),
                                                  ),
                                                  border:
                                                  InputBorder.none,
                                                  hintText: Locales.string(
                                                      context,
                                                      'write_message'),
                                                  suffixIcon:
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (_messageController
                                                          .text
                                                          .isNotEmpty) {
                                                        context
                                                            .read<
                                                            TasksBloc>()
                                                            .add(TasksAddCommentEvent(
                                                            id: state
                                                                .task
                                                                .id,
                                                            comment:
                                                            _messageController
                                                                .text,
                                                            comment_type:
                                                            'text'));
                                                        context
                                                            .read<
                                                            TasksBloc>()
                                                            .add(TasksShowEvent(
                                                            id: state
                                                                .task
                                                                .id));
                                                        _messageController
                                                            .clear();
                                                      }
                                                    },
                                                    child: Container(
                                                      margin:
                                                      const EdgeInsets
                                                          .all(5),
                                                      child: SvgPicture
                                                          .asset(
                                                        'assets/icons_svg/send.svg',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                onEditingComplete: () {
                                                  if (_messageController.text.isNotEmpty) {
                                                    context.read<TasksBloc>()
                                                        .add(TasksAddCommentEvent(
                                                        id: state
                                                            .task.id,
                                                        comment:
                                                        _messageController
                                                            .text,
                                                        comment_type:
                                                        'text'));
                                                    context
                                                        .read<TasksBloc>()
                                                        .add(
                                                        TasksShowEvent(
                                                            id: state
                                                                .task
                                                                .id));
                                                    _messageController
                                                        .clear();
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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
            bottomNavigationBar: MainBottomBar(isMain: false),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
              ),
            ),
          );
        }
      }),
    );
  }
}
