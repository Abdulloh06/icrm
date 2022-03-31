import 'dart:io';
import 'package:avlo/core/models/tasks_model.dart';
import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:avlo/core/util/text_styles.dart';
import 'package:avlo/features/presentation/blocs/attachment_bloc/attachment_bloc.dart';
import 'package:avlo/features/presentation/blocs/tasks_bloc/tasks_bloc.dart';
import 'package:avlo/features/presentation/pages/project/pages/project_document_page.dart';
import 'package:avlo/features/presentation/pages/tasks/pages/calendar.dart';
import 'package:avlo/features/presentation/pages/tasks/pages/create_task.dart';
import 'package:avlo/widgets/circular_progress_bar.dart';
import 'package:avlo/widgets/main_app_bar.dart';
import 'package:avlo/widgets/main_bottom_bar.dart';
import 'package:avlo/widgets/main_tab_bar.dart';
import 'package:avlo/widgets/message_card.dart';
import 'package:avlo/widgets/projects.dart';
import 'package:avlo/widgets/update_members.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../../blocs/attachment_bloc/attachment_event.dart';
import '../components/priority.dart';

class TaskPage extends StatefulWidget {
  TaskPage({
    Key? key,
    required this.id,
  }) : super(key: key) {}

  final int id;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<AttachmentBloc>().add(AttachmentShowEvent(content_type: 'task', content_id: widget.id));
    context.read<TasksBloc>().add(TasksShowEvent(id: widget.id));

    return DefaultTabController(
      length: 3,
      child: WillPopScope(
        onWillPop: () async {
          context.read<TasksBloc>().add(TasksInitEvent());
          return true;
        },
        child: BlocBuilder<TasksBloc, TasksState>(builder: (context, state) {
          if (state is TasksUpdateState) {
            context.read<TasksBloc>().add(TasksShowEvent(id: widget.id));
          }

          if (state is TasksShowState) {
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size(double.infinity, 52),
                child: AppBarBack(
                  onTap: () {
                    context.read<TasksBloc>().add(TasksInitEvent());
                    Navigator.pop(context);
                  },
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
                        Container(
                          decoration: BoxDecoration(
                            color: UserToken.isDark
                                ? AppColors.mainDark
                                : Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          padding: EdgeInsets.only(
                              top: 23, right: 20, left: 20, bottom: 11),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      state.task.name,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.headerTask,
                                    ),
                                  ),
                                  GestureDetector(
                                    child: SvgPicture.asset('assets/icons_svg/edit.svg'),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTask(
                                        fromEdit: true,
                                        task: state.task,
                                      )));
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Text(
                                state.task.description,
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
                                            task: state.task,
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: UserToken.isDark
                                            ? AppColors.cardColorDark
                                            : Color.fromARGB(
                                                255, 245, 245, 250),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons_svg/calendar_bg.svg',
                                          ),
                                          SizedBox(width: 8),
                                          Builder(
                                            builder: (context) {
                                              if (state.task.startDate != '') {
                                                return Text(
                                                  DateFormat("dd.MM.yyyy")
                                                      .format(DateTime
                                                      .parse(state.task
                                                      .startDate)) +
                                                      " - " +
                                                      DateFormat("dd.MM.yyyy")
                                                          .format(DateTime
                                                              .parse(state.task
                                                                  .deadline)),
                                                  style: AppTextStyles
                                                      .descriptionGrey,
                                                );
                                              } else {
                                                return Text(
                                                  DateFormat("dd.MM.yyyy")
                                                      .format(DateTime.parse(
                                                          state.task.deadline)),
                                                  style: AppTextStyles
                                                      .descriptionGrey,
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 36),
                                  Builder(
                                    builder: (context) {
                                      if(state.taskStatuses.indexWhere((element) => element.id == state.task.taskStatusId) == 0) {
                                        return CircularProgressBar(percent: 5);
                                      } else if(state.task.taskStatusId == state.taskStatuses.last.id) {
                                        return CircularProgressBar(percent: 100);
                                      } else {
                                        return CircularProgressBar(percent: 95 / (state.taskStatuses.length.toDouble() - 1) * (state.taskStatuses.indexWhere((element) => element.id == state.task.taskStatusId)));
                                      }
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 14),
                              LocaleText(
                                'team',
                                style: AppTextStyles.mainTextFont.copyWith(
                                    color: UserToken.isDark
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.065,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:
                                                state.task.members!.length != 1
                                                    ? 108
                                                    : 50,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  state.task.members!.length,
                                              itemBuilder: (context, index) {
                                                return ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl: state
                                                        .task
                                                        .members![index]
                                                        .social_avatar,
                                                    errorWidget: (context,
                                                        error, stackTrace) {
                                                      return Image.asset(
                                                          'assets/png/no_user.png');
                                                    },
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

                                                  for (int i = 0; i < state.task.members!.length; i++) {
                                                    assigns.add(state.task.members![i].id);
                                                  }

                                                  return UpdateMembers(
                                                    task_id: state.task.id,
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
                                        return List.generate(
                                            state.taskStatuses.length, (index) {
                                          return PopupMenuItem(
                                            onTap: () {
                                              context.read<TasksBloc>().add(
                                                TasksUpdateEvent(
                                                  id: state.task.id,
                                                  name: state.task.name,
                                                  start_date: state.task.startDate,
                                                  deadline: state.task.deadline,
                                                  priority: state.task.priority,
                                                  description: state.task.description,
                                                  status: state.taskStatuses[index].id,
                                                  parent_id: state.task.parentId,
                                                  taskType: state.task.taskType.split('\\').last.toLowerCase(),
                                                  taskId: state.task.taskId,
                                                ),
                                              );
                                            },
                                            padding: const EdgeInsets.only(
                                                right: 10),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 8),
                                              child: Text(
                                                state.taskStatuses[index].name,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Color(int.parse(state
                                              .task.taskStatus!.color
                                              .split('#')
                                              .join('0xff'))),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          state.task.taskStatus!.name,
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
                        ),
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CreateTask(
                                                                parent_id: state
                                                                    .task.id,
                                                                task_type:
                                                                    'user',
                                                                task_id: state
                                                                    .task.id,
                                                              )));
                                                },
                                                child: Row(
                                                  children: [
                                                    LocaleText(
                                                      'add',
                                                      style: AppTextStyles
                                                          .mainBold
                                                          .copyWith(
                                                        color: UserToken.isDark
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
                                          BlocBuilder<TasksBloc, TasksState>(
                                              builder: (context, state) {
                                            if (state is TasksShowState) {
                                              List<TasksModel> subtasks =
                                                  state.task.subtasks ?? [];

                                              if (subtasks.isNotEmpty) {
                                                return Expanded(
                                                  child: ListView.builder(
                                                    itemCount: subtasks.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        padding: const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 8)
                                                            .copyWith(
                                                                right: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: UserToken
                                                                  .isDark
                                                              ? AppColors
                                                                  .cardColorDark
                                                              : Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              spreadRadius: 0.1,
                                                              blurRadius: 0.1,
                                                              color: AppColors
                                                                  .greyDark,
                                                            ),
                                                          ],
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Checkbox(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              activeColor:
                                                                  AppColors
                                                                      .greyLight,
                                                              checkColor:
                                                                  Colors.white,
                                                              value: true,
                                                              onChanged:
                                                                  (value) {},
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  Text(
                                                                    subtasks[
                                                                            index]
                                                                        .name,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      color: UserToken.isDark
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  LinearProgressIndicator(
                                                                    color: AppColors
                                                                        .green,
                                                                    backgroundColor: UserToken.isDark
                                                                        ? Colors
                                                                            .white
                                                                        : AppColors
                                                                            .apColor,
                                                                    value: 0.5,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 15),
                                                            Row(
                                                              children: [
                                                                CircleAvatar(
                                                                  backgroundImage:
                                                                      AssetImage(
                                                                          'assets/png/img.png'),
                                                                ),
                                                                CircleAvatar(
                                                                  backgroundImage:
                                                                      AssetImage(
                                                                          'assets/png/img.png'),
                                                                ),
                                                                const SizedBox(
                                                                    width: 10),
                                                                SvgPicture.asset(
                                                                    'assets/icons_svg/next.svg'),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                              } else {
                                                return Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: LocaleText('empty'),
                                                );
                                              }
                                            } else if (state
                                                    is TasksInitState &&
                                                state.tasks.isNotEmpty) {
                                              return Center(
                                                child: LocaleText('empty'),
                                              );
                                            } else {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: AppColors.mainColor,
                                                ),
                                              );
                                            }
                                          }),
                                        ],
                                      ),
                                    ),
                                    ProjectDocumentPage(
                                      project_id: state.task.id,
                                      content_type: 'task',
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: BlocBuilder<TasksBloc, TasksState>(
                                          builder: (context, state) {
                                        if (state is TasksShowState) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(10)),
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
                                                    itemCount: state
                                                        .task.comments.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GestureDetector(
                                                        onLongPress: () {},
                                                        child: MessageCard(
                                                          parent_id: state
                                                              .task
                                                              .comments[index]
                                                              .parent_id,
                                                          job: UserToken
                                                              .responsibility,
                                                          name: UserToken.name,
                                                          id: state
                                                              .task
                                                              .comments[index]
                                                              .id,
                                                          date: state
                                                              .task
                                                              .comments[index]
                                                              .created_at,
                                                          message: state
                                                              .task
                                                              .comments[index]
                                                              .content,
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
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: UserToken.isDark
                                                          ? AppColors.mainDark
                                                          : Color.fromRGBO(
                                                              241, 244, 247, 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: TextField(
                                                      controller:
                                                          _messageController,
                                                      cursorColor:
                                                          AppColors.mainColor,
                                                      decoration:
                                                          InputDecoration(
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
                                                        if (_messageController
                                                            .text.isNotEmpty) {
                                                          context
                                                              .read<TasksBloc>()
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
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.mainColor,
                                            ),
                                          );
                                        }
                                      }),
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
      ),
    );
  }
}

class SqliteApp extends StatefulWidget {
  const SqliteApp({Key? key}) : super(key: key);

  @override
  _SqliteAppState createState() => _SqliteAppState();
}

class _SqliteAppState extends State<SqliteApp> {
  int? selectedId;
  final textController = TextEditingController();
  bool isRemove = false;
  bool showTextField = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          /**      Projects       * */

          Container(
            height: 90,
            // color: Colors.green,
            child: FutureBuilder<List<Grocery>>(
                future: DatabaseHelper.instance.getGroceries(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Grocery>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Text('Loading...'));
                  }
                  return snapshot.data!.isEmpty
                      ? Center(child: LocaleText('empty'))
                      : ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data!.map((grocery) {
                            return Container(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onLongPress: () {
                                  setState(() {
                                    isRemove = !isRemove;
                                  });
                                },
                                child: Container(
                                  height: 45,
                                  child: Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        Projects(
                                            title: grocery.name,
                                            background: Color.fromARGB(
                                                255, 231, 247, 235),
                                            textColor: Color.fromARGB(
                                                255, 97, 200, 119),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            splashColor: Color.fromARGB(
                                                1, 144, 239, 165)),
                                        Positioned(
                                          top: 0,
                                          child: Visibility(
                                            visible: isRemove,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 20,
                                                  padding: EdgeInsets.only(
                                                      bottom: 20),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      selectedId != null
                                                          ? textController
                                                                      .text ==
                                                                  ''
                                                              ? null
                                                              : await DatabaseHelper
                                                                  .instance
                                                                  .update(Grocery(
                                                                      id:
                                                                          selectedId,
                                                                      name: textController
                                                                          .text))
                                                          : textController
                                                                      .text ==
                                                                  ''
                                                              ? null
                                                              : await DatabaseHelper
                                                                  .instance
                                                                  .add(Grocery(
                                                                      name: textController
                                                                          .text));
                                                      setState(() {
                                                        textController.clear();
                                                        selectedId = null;
                                                        showTextField =
                                                            !showTextField;
                                                      });
                                                      setState(() {
                                                        textController.text =
                                                            grocery.name;
                                                        selectedId = grocery.id;
                                                      });
                                                    },
                                                    child: SvgPicture.asset(
                                                        'assets/icons_svg/editable.svg',
                                                        height: 18,
                                                        width: 20),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Container(
                                                  width: 20,
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          DatabaseHelper
                                                              .instance
                                                              .remove(
                                                                  grocery.id!);
                                                          isRemove = !isRemove;
                                                        });
                                                      },
                                                      child: RotationTransition(
                                                        alignment:
                                                            Alignment.topRight,
                                                        turns:
                                                            AlwaysStoppedAnimation(
                                                                45 / 360),
                                                        child: SvgPicture.asset(
                                                            'assets/icons_svg/add_icon.svg',
                                                            height: 18),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ]),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                }),
          ),
          /**      Add button       **/
          Positioned(
            height: showTextField == false ? 25 : 35,
            top: 8,
            right: 10,
            child: GestureDetector(
              child: SvgPicture.asset(
                'assets/icons_svg/add_icon.svg',
                height: showTextField == false ? 25 : 35,
              ),
              onTap: () async {
                selectedId != null
                    ? textController.text == ''
                        ? null
                        : await DatabaseHelper.instance.update(
                            Grocery(id: selectedId, name: textController.text),
                          )
                    : textController.text == ''
                        ? null
                        : await DatabaseHelper.instance.add(
                            Grocery(name: textController.text),
                          );
                setState(() {
                  textController.clear();
                  selectedId = null;
                  showTextField = !showTextField;
                });
              },
            ),
          ),
          /**      Add textfield       **/
          showTextField == true
              ? Positioned(
                  child: Container(
                  margin: EdgeInsets.only(right: 50),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 40,
                  width: 300,
                  child: TextField(
                      cursorHeight: 20,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Write'),
                      controller: textController),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color:
                          UserToken.isDark ? AppColors.mainDark : Colors.white,
                      border: Border.all(width: 1, color: AppColors.mainColor),
                      boxShadow: UserToken.isDark
                          ? [
                              BoxShadow(
                                  color: Colors.grey.shade800,
                                  blurRadius: 6,
                                  spreadRadius: 3,
                                  offset: Offset(0, 3))
                            ]
                          : [
                              BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 6,
                                  spreadRadius: 3,
                                  offset: Offset(0, 3))
                            ]),
                ))
              : Container(),
        ],
      ),
    );
  }
}

class Grocery {
  final int? id;
  final String name;

  Grocery({this.id, required this.name});

  factory Grocery.fromMap(Map<String, dynamic> json) => Grocery(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'groceries.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE groceries(
          id INTEGER PRIMARY KEY,
          name TEXT
      )
      ''');
  }

  Future<List<Grocery>> getGroceries() async {
    Database db = await instance.database;
    var groceries = await db.query('groceries', orderBy: 'name');
    List<Grocery> groceryList = groceries.isNotEmpty
        ? groceries.map((c) => Grocery.fromMap(c)).toList()
        : [];
    return groceryList;
  }

  Future<int> add(Grocery grocery) async {
    Database db = await instance.database;
    return await db.insert('groceries', grocery.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('groceries', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Grocery grocery) async {
    Database db = await instance.database;
    return await db.update('groceries', grocery.toMap(),
        where: 'id = ?', whereArgs: [grocery.id]);
  }
}
