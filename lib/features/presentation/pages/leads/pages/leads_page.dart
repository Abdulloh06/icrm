/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/projects_model.dart';
import '../components/leads_page_includes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';

class LeadsPage extends StatefulWidget {
  LeadsPage({
    Key? key,
    required this.lead,
    required this.leadStatuses,
    this.toMessage = false,
    this.project,
    this.fromProject = false,
  }) : super(key: key);

  final LeadsModel lead;
  final List<StatusModel> leadStatuses;
  final bool toMessage;
  final bool fromProject;
  final ProjectsModel? project;

  @override
  State<LeadsPage> createState() => _LeadsPageState();
}

class _LeadsPageState extends State<LeadsPage> with TickerProviderStateMixin{

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late final TabController _tabController;

  late LeadsModel lead;
  late ProjectsModel? project;
  List<StatusModel> leadStatus = [];
  late final double maxHeight;
  int tries = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    lead = widget.lead;
    leadStatus = widget.leadStatuses;
    if(widget.fromProject) {
      project = widget.project!;
    }else {
      if(lead.project != null) {
        project = widget.lead.project!;
      }
    }
    context.read<LeadMessageBloc>().add(LeadMessageInitEvent(id: widget.lead.id));
    context.read<AttachmentBloc>().add(AttachmentShowEvent(content_type: 'lead', content_id: widget.lead.id));
  }

  @override
  Widget build(BuildContext context) {
    if(widget.toMessage) {
      _tabController.animateTo(2);
    }

    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if(state is HomeInitState) {
          lead = state.leads.elementAt(state.leads.indexWhere((element) => element.id == lead.id));
          leadStatus = leadStatus;
          setState(() {});
        }
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          key: _scaffoldKey,
          endDrawer: const MainDrawer(),
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 52),
            child: MainAppBar(
              project: true,
              title: project != null ? project!.name : "",
              scaffoldKey: _scaffoldKey,
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              tries++;
              if(tries <= 2) {
                maxHeight = constraints.maxHeight;
              }
              return ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: maxHeight,
                    child: CustomScrollView(
                      scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
                      slivers: [
                        SliverToBoxAdapter(
                          child: MainLeadInfo(
                            fromProject: widget.fromProject,
                            project: project,
                            lead: lead,
                            leadStatus: leadStatus,
                          ),
                        ),
                        SliverFillRemaining(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 10),
                                child: MainTabBar(
                                  controller: _tabController,
                                  tabs: [
                                    Tab(
                                      text: Locales.string(context, 'task_list'),
                                    ),
                                    Tab(
                                      text: Locales.string(context, 'files'),
                                    ),
                                    Tab(
                                      text: Locales.string(context, 'lead_chat'),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    LeadTasks(
                                      id: lead.id,
                                      tasks: lead.tasks ?? [],
                                    ),
                                    ProjectDocumentPage(
                                      content_type: 'lead',
                                      project_id: lead.id,
                                    ),
                                    LeadMessagesPage(lead: lead),
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
              );
            }
          ),
          bottomNavigationBar: MainBottomBar(isMain: false),
        ),
      ),
    );
  }
}


