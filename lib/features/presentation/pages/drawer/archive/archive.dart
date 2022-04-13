/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/features/presentation/blocs/archive_bloc/archive_bloc.dart';
import 'package:icrm/features/presentation/blocs/archive_bloc/archive_state.dart';
import 'package:icrm/features/presentation/pages/drawer/archive/components/archive_leads.dart';
import 'package:icrm/features/presentation/pages/drawer/archive/components/archive_projects.dart';
import 'package:icrm/features/presentation/pages/drawer/archive/components/archive_tasks.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:icrm/widgets/main_app_bar.dart';
import 'package:icrm/widgets/main_search_bar.dart';
import 'package:icrm/widgets/main_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';

class Archive extends StatelessWidget {
  Archive({Key? key}) : super(key: key);

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<ArchiveBloc>().add(ArchiveInitEvent());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 52),
          child: AppBarBack(
            title: 'archive',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              MainTabBar(
                tabs: [
                  Tab(text: Locales.string(context, 'projects')),
                  Tab(text: Locales.string(context, 'leads')),
                  Tab(text: Locales.string(context, 'tasks')),
                ],
              ),
              const SizedBox(height: 20,),
              Expanded(
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      children: [
                        MainSearchBar(
                          controller: _searchController,
                          onComplete: () {},
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 20),
                        ScrollConfiguration(
                          behavior: const ScrollBehavior().copyWith(overscroll: false),
                          child: BlocBuilder<ArchiveBloc, ArchiveState>(
                              builder: (context, state) {
                                if(state is ArchiveInitState) {
                                  return Expanded(
                                    child: TabBarView(
                                      children: [
                                        ArchiveProjects(
                                          projects: state.projects,
                                          search: _searchController.text,
                                        ),
                                        ArchiveLeads(
                                          leads: state.leads,
                                          search: _searchController.text,
                                        ),
                                        ArchiveTasks(
                                          tasks: state.tasks,
                                          search: _searchController.text,
                                        ),
                                      ],
                                    ),
                                  );
                                }else {
                                  return Loading();
                                }
                              }
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
