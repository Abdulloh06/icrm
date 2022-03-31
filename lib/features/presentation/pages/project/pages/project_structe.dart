import 'package:avlo/core/models/leads_model.dart';
import 'package:avlo/core/models/tasks_model.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:avlo/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:avlo/features/presentation/blocs/projects_bloc/projects_event.dart';
import 'package:avlo/features/presentation/blocs/projects_bloc/projects_state.dart';
import 'package:avlo/features/presentation/pages/project/components/general_page.dart';
import 'package:avlo/features/presentation/pages/project/pages/project_document_page.dart';
import 'package:avlo/features/presentation/pages/project/pages/projects_task_page.dart';
import 'package:avlo/widgets/drawer.dart';
import 'package:avlo/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import '../../../blocs/tasks_bloc/tasks_bloc.dart';
import 'projects_lead_page.dart';

class ProjectStructure extends StatefulWidget {
  ProjectStructure({
    Key? key,
    required this.id,
    required this.name,
    required this.description,
    required this.user_id,
    required this.company_id,
    required this.project_status_id,
    required this.user_category,
    required this.notify_at,
    required this.price,
    required this.currency,
    required this.created_at,
    required this.updated_at,
    required this.leads,
    required this.tasks,
  }) : super(key: key);

  final int id;
  final int user_id;
  final int project_status_id;
  final int user_category;
  final int company_id;
  final String name;
  final String description;
  final String notify_at;
  final dynamic price;
  final String currency;
  final String created_at;
  final String updated_at;
  final List<LeadsModel> leads;
  final List<TasksModel> tasks;

  @override
  State<ProjectStructure> createState() => _ProjectStructureState();
}

class _ProjectStructureState extends State<ProjectStructure> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    context.read<TasksBloc>().add(TasksInitEvent());
    context.read<ProjectsBloc>().add(ProjectsShowEvent(id: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<ProjectsBloc>().add(ProjectsInitEvent());
        return true;
      },
      child: DefaultTabController(
        length: 4,
        child: BlocBuilder<ProjectsBloc, ProjectsState>(
          builder: (context, state) {
            if(state is ProjectsShowState) {
              return Scaffold(
                key: _scaffoldKey,
                appBar: PreferredSize(
                  preferredSize: Size(double.infinity, 52),
                  child: MainAppBar(
                    scaffoldKey: _scaffoldKey,
                    title: widget.name,
                    project: true,
                    onTap: () {
                      context.read<ProjectsBloc>().add(ProjectsInitEvent());
                      Navigator.pop(context);
                    },
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
                            text: Locales.string(context, 'led'),
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
                              company_id: widget.company_id,
                              id: widget.id,
                            ),
                            ProjectLeadPage(
                              projectId: widget.id,
                            ),
                            ProjectsTaskPage(id: widget.id),
                            ProjectDocumentPage(
                              project_id: widget.id,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.mainColor,
                  ),
                ),
              );
            }
          }
        ),
      ),
    );
  }
}
