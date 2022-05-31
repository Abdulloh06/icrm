/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/comments_model.dart';
import 'package:icrm/core/models/tasks_model.dart';
import 'package:icrm/features/presentation/blocs/attachment_bloc/attachment_bloc.dart';
import 'package:icrm/features/presentation/blocs/tasks_bloc/tasks_bloc.dart';
import 'package:icrm/features/presentation/pages/project/pages/project_document_page.dart';
import 'package:icrm/features/presentation/pages/tasks/pages/selected_task/components/main_info.dart';
import 'package:icrm/features/presentation/pages/tasks/pages/selected_task/components/priority_popup.dart';
import 'package:icrm/features/presentation/pages/tasks/pages/selected_task/components/subtasks_list.dart';
import 'package:icrm/features/presentation/pages/tasks/pages/selected_task/components/task_chat.dart';
import 'package:icrm/widgets/main_app_bar.dart';
import 'package:icrm/widgets/main_bottom_bar.dart';
import 'package:icrm/widgets/main_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import '../../../../../../core/models/status_model.dart';
import '../../../../blocs/attachment_bloc/attachment_event.dart';

class TaskPage extends StatefulWidget {
  TaskPage({
    Key? key,
    required this.task,
    required this.taskStatuses,
  }) : super(key: key);

  final TasksModel task;
  final List<StatusModel> taskStatuses;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> with TickerProviderStateMixin{
  late final TabController _tabController;

  late TasksModel task;
  late int taskStatus;
  late String start_date;
  late String deadline;
  
  late List<CommentsModel> comments;
  late List<TasksModel> subtasks;

  int tries = 1;
  late final double maxHeight;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    task = widget.task;
    comments = widget.task.comments;
    subtasks = widget.task.subtasks ?? [];
    taskStatus = widget.task.taskStatusId;
    start_date = widget.task.startDate;
    deadline = widget.task.deadline;

    context.read<AttachmentBloc>().add(AttachmentShowEvent(
      content_type: 'task',
      content_id: task.id,
    ));
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: BlocListener<TasksBloc, TasksState>(
        listener: (context, state) {
          if(state is TasksInitState) {
            try {
              task = state.tasks.elementAt(state.tasks.indexWhere((element) => element.id == task.id));
              setState(() {});
            }catch(_) {}
          }
        },
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 52),
              child: AppBarBack(
                titleWidget: PriorityPopUp(
                  task: task,
                ),
                title: '',
              ),
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                tries++;
                if(tries <= 2) {
                  maxHeight = constraints.maxHeight;
                }
                return SingleChildScrollView(
                  child: SizedBox(
                    height: maxHeight,
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: MainTaskInfo(
                            task: task,
                            taskStatuses: widget.taskStatuses,
                          ),
                        ),
                        SliverFillRemaining(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ).copyWith(top: 30),
                                child: MainTabBar(
                                  controller: _tabController,
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
                                      text: Locales.string(context, 'sub_task'),
                                    ),
                                    Tab(
                                      text: Locales.string(context, 'files'),
                                    ),
                                    Tab(
                                      text: Locales.string(context, 'chat'),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    SubtasksList(taskId: task.taskId, parentId: task.id, subtasks: subtasks),
                                    ProjectDocumentPage(
                                      project_id: task.id,
                                      content_type: 'task',
                                    ),
                                    TaskChat(comments: comments, taskId: task.id),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
            bottomNavigationBar: MainBottomBar(isMain: false),
          ),
        ),
      ),
    );
  }
}
