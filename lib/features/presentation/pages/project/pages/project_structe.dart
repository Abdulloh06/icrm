/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/projects_model.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/features/presentation/blocs/attachment_bloc/attachment_bloc.dart';
import 'package:icrm/features/presentation/blocs/attachment_bloc/attachment_event.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_state.dart';
import 'package:icrm/features/presentation/pages/project/components/general_page.dart';
import 'package:icrm/features/presentation/pages/project/pages/project_document_page.dart';
import 'package:icrm/features/presentation/pages/project/pages/projects_task_page.dart';
import 'package:icrm/widgets/drawer.dart';
import 'package:icrm/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import '../../../../../core/models/status_model.dart';
import '../../../blocs/company_bloc/company_bloc.dart';
import '../../../blocs/tasks_bloc/tasks_bloc.dart';
import 'projects_lead_page.dart';

class ProjectStructure extends StatefulWidget {
  ProjectStructure({
    Key? key,
    required this.project,
    required this.projectStatus,
  }) : super(key: key);

  final ProjectsModel project;
  final List<StatusModel> projectStatus;

  @override
  State<ProjectStructure> createState() => _ProjectStructureState();
}

class _ProjectStructureState extends State<ProjectStructure> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isEdit = false;
  
  late ProjectsModel project;
  late List<StatusModel> projectStatus;

  @override
  void initState() {
    super.initState();
    project = widget.project;
    projectStatus = widget.projectStatus;
    context.read<TasksBloc>().add(TasksInitEvent());
    context.read<AttachmentBloc>().add(AttachmentShowEvent(content_type: 'project', content_id: project.id));
    if(project.company_id != null) {
      context.read<CompanyBloc>().add(CompanyShowEvent(id: project.company_id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: BlocListener<ProjectsBloc, ProjectsState>(
        listener: (context, state) {
          if(state is ProjectsInitState) {
            project = state.projects.elementAt(
              state.projects.indexWhere((element) => element.id == project.id),
            );
            projectStatus = state.projectStatus;
            setState(() {});
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 52),
            child: MainAppBar(
              scaffoldKey: _scaffoldKey,
              title: project.name,
              project: true,
            ),
          ),
          endDrawer: const MainDrawer(),
          body: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: TabBar(
                  labelPadding: const EdgeInsets.all(0),
                  labelStyle: TextStyle(fontSize: 12),
                  unselectedLabelColor: AppColors.mainColor,
                  automaticIndicatorColorAdjustment: false,
                  indicator: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tabs: [
                    Tab(
                      text: Locales.string(context, 'general'),
                    ),
                    Tab(
                      text: Locales.string(context, 'lead'),
                    ),
                    Tab(
                      text: Locales.string(context, 'tasks'),
                    ),
                    Tab(
                      text: Locales.string(context, 'documentation'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: TabBarView(
                    children: [
                      GeneralPage(
                        project: project,
                        projectStatus: projectStatus.where((element) => element.userLabel != null).toList(),
                      ),
                      ProjectLeadPage(
                        project: project,
                        leads: project.leads ?? [],
                      ),
                      ProjectsTaskPage(
                        id: project.id,
                        tasks: project.tasks ?? [],
                      ),
                      ProjectDocumentPage(
                        project_id: project.id,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
