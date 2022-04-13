/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/features/presentation/blocs/home_bloc/home_event.dart';
import 'package:icrm/features/presentation/pages/leads/pages/leads_page_includes.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import '../leads/components/lead_messages_page.dart';
import '../leads/components/lead_tasks.dart';

class AddLeadsPage extends StatefulWidget {
  AddLeadsPage({
    Key? key,
    required this.id,
    required this.phone_number,
  }) : super(key: key);

  final int id;
  final String phone_number;

  @override
  State<AddLeadsPage> createState() => _AddLeadsPageState();
}

class _AddLeadsPageState extends State<AddLeadsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static String phoneNumber = '';

  @override
  void initState() {
    super.initState();
    phoneNumber = widget.phone_number;
    context.read<HomeBloc>().add(LeadsShowEvent(id: widget.id));
    context.read<AttachmentBloc>().add(AttachmentShowEvent(content_type: 'lead', content_id: widget.id));
    context.read<LeadMessageBloc>().add(LeadMessageInitEvent(id: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<HomeBloc>().add(HomeInitEvent());
        return true;
      },
      child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        if (state is LeadShowState) {
          if(widget.phone_number == '' && state.lead.contact != null) {
            phoneNumber = state.lead.contact!.phone_number;
          }
          return DefaultTabController(
            length: 3,
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Scaffold(
                    key: _scaffoldKey,
                    endDrawer: const MainDrawer(),
                    appBar: PreferredSize(
                      preferredSize: Size(double.infinity, 52),
                      child: MainAppBar(
                        project: true,
                        title: state.lead.project!.name,
                        scaffoldKey: _scaffoldKey,
                        onTap: () {
                          context.read<HomeBloc>().add(HomeInitEvent());
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainLeadInfo(lead: state.lead, leadStatus: state.leadStatus),
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20).copyWith(bottom: 0),
                                child: MainTabBar(
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
                                  children: [
                                    LeadTasks(
                                      id: state.lead.id,
                                      tasks: state.lead.tasks ?? [],
                                    ),
                                    ProjectDocumentPage(
                                      project_id: state.lead.projectId,
                                    ),
                                    LeadMessagesPage(lead: state.lead),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    bottomNavigationBar: MainBottomBar(isMain: false),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Loading(),
          );
        }
      }),
    );
  }
}
