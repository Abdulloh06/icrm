import 'package:icrm/features/presentation/blocs/search_bloc/search_bloc.dart';
import 'package:icrm/features/presentation/blocs/search_bloc/search_event.dart';
import 'package:icrm/features/presentation/blocs/search_bloc/search_state.dart';
import 'package:icrm/features/presentation/pages/seacrh_page/components/search_leads.dart';
import 'package:icrm/features/presentation/pages/seacrh_page/components/search_projects.dart';
import 'package:icrm/features/presentation/pages/seacrh_page/components/search_tasks.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:icrm/widgets/main_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import '../../../../core/util/colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key,}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: MainSearchBar(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {});
                            },
                            onComplete: () {},
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: LocaleText(
                          "cancel",
                          style: TextStyle(
                            color: AppColors.mainColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TabBar(
                  labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  unselectedLabelColor: AppColors.mainColor,
                  indicatorPadding: const EdgeInsets.all(10),
                  indicator: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  tabs: [
                    Tab(text: Locales.string(context, 'projects'),),
                    Tab(text: Locales.string(context, 'leads'),),
                    Tab(text: Locales.string(context, 'tasks'),),
                  ],
                ),
                const SizedBox(height: 20),
                BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if(state is SearchInitState) {
                      return Expanded(
                        child: TabBarView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: SearchProjects(
                                search: _searchController.text,
                                projects: state.projects,
                                projectStatuses: state.projectStatuses.where((element) => element.userLabel != null).toList(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: SearchLeads(
                                search: _searchController.text,
                                leads: state.leads,
                                leadStatuses: state.leadStatuses.where((element) => element.userLabel != null).toList(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: SearchTasks(
                                search: _searchController.text,
                                tasks: state.tasks,
                                taskStatuses: state.taskStatuses.where((element) => element.userLabel != null).toList(),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      context.read<SearchBloc>().add(SearchInitEvent());
                      return Loading();
                    }
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
