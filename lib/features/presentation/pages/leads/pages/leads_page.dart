/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:icrm/features/presentation/pages/leads/components/lead_messages_page.dart';
import 'package:icrm/features/presentation/pages/leads/components/lead_tasks.dart';
import 'package:icrm/main.dart';
import 'package:telephony/telephony.dart';
import 'leads_page_includes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';

class LeadsPage extends StatefulWidget {
  LeadsPage({
    Key? key,
    required this.lead,
    required this.leadStatuses,
    required this.phone_number,
    this.toMessage = false,
  }) : super(key: key);

  final LeadsModel lead;
  final List<LeadsStatusModel> leadStatuses;
  final String phone_number;
  final bool toMessage;

  @override
  State<LeadsPage> createState() => _LeadsPageState();
}

class _LeadsPageState extends State<LeadsPage> with TickerProviderStateMixin{
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _telephony = Telephony.instance;
  late final TabController _tabController;

  late LeadsModel lead;
  List<LeadsStatusModel> leadStatus = [];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);

    lead = widget.lead;
    leadStatus = widget.leadStatuses;

    if (Platform.isAndroid && widget.lead.contact != null) {
      _telephony.listenIncomingSms(
        onNewMessage: (message) {
          if(message.address!.split('+').join() == widget.lead.contact!.phone_number.split('+').join()) {
            if(message.body != null && message.body!.isNotEmpty) {
              print(message.body);
              return context.read<LeadMessageBloc>().add(LeadMessagesSendEvent(
                lead_id: widget.lead.id,
                message: message.body!,
                user_id: null,
                client_id: widget.lead.contactId,
              ),
              );
            }
          }
        },
        onBackgroundMessage: backgroundMessageHandler,
        listenInBackground: true,
      );
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
                    title: lead.project!.name,
                    scaffoldKey: _scaffoldKey,
                  ),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainLeadInfo(lead: lead, leadStatus: leadStatus),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20).copyWith(bottom: 0),
                            child: SizedBox(
                              height: 52,
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
                                  project_id: lead.projectId,
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
                bottomNavigationBar: MainBottomBar(isMain: false),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


