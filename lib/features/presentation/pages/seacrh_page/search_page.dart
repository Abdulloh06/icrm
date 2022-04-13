/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/tasks_model.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_state.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_state.dart';
import 'package:icrm/features/presentation/blocs/tasks_bloc/tasks_bloc.dart';
import 'package:icrm/features/presentation/pages/tasks/components/gridview_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/repository/user_token.dart';
import '../../../../core/util/colors.dart';
import '../../../../core/util/text_styles.dart';
import '../../../../widgets/main_lead_card.dart';
import '../leads/pages/leads_page.dart';
import '../project/pages/project_structe.dart';
import '../tasks/pages/selected_tasks.dart';

//ignore:must_be_immutable
class SearchPage extends StatelessWidget {
  SearchPage({
    Key? key,
    required this.search,
  }) : super(key: key);

  final String search;
  bool _canBuild = true;
  bool _canBuildLead = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBody: true,
        body: SafeArea(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 10),
              child: Column(
                children: [
                  TabBar(
                    labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                    unselectedLabelColor: AppColors.mainColor,
                    indicatorPadding: const EdgeInsets.all(10),
                    indicator: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    tabs: [
                      Tab(text: Locales.string(context, 'projects'),),
                      Tab(text: Locales.string(context, 'leads'),),
                      Tab(text: Locales.string(context, 'tasks'),),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: TabBarView(
                      children: [
                        BlocBuilder<ProjectsBloc, ProjectsState>(
                          builder: (context, state) {
                            if(state is ProjectsInitState && state.projects.isNotEmpty) {
                              return ListView.builder(
                                itemCount: state.projects.length,
                                itemBuilder: (context, index) {
                                  return Visibility(
                                    visible: state.projects[index].name.toLowerCase().contains(search.toLowerCase()),
                                    child: GestureDetector(
                                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectStructure(
                                        project: state.projects[index],
                                        projectStatus: state.projectStatus,
                                      ))),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                                        decoration: BoxDecoration(
                                          color: UserToken.isDark ? AppColors.mainDark : Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        margin: const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                state.projects[index].name,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppTextStyles.proText.copyWith(
                                                  color: !UserToken.isDark ? AppColors.mainColor : Colors.white,
                                                ),
                                              ),
                                            ),
                                            SvgPicture.asset("assets/icons_svg/vect.svg"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if(state is ProjectsInitState && state.projects.isEmpty) {
                              return Center(
                                child: LocaleText('empty', style: AppTextStyles.mainGrey),
                              );
                            } else if(state is ProjectsErrorState){
                              return Center(
                                child: Text(state.error),
                              );
                            }else {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.mainColor,
                                ),
                              );
                            }
                          },
                        ),
                        BlocBuilder<HomeBloc, HomeState>(
                          buildWhen: (context, state) => _canBuildLead,
                          builder: (context, state) {
                            if (state is HomeInitState && state.leads.isNotEmpty) {
                              return ListView.builder(
                                  itemCount: state.leads.length,
                                  itemBuilder: (context, index) {
                                    return Visibility(
                                      visible: state.leads[index].contact!.name.toLowerCase().contains(search.toLowerCase()),
                                      child: GestureDetector(
                                        onTap: () async {
                                          _canBuildLead = false;
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LeadsPage(
                                                lead: state.leads[index],
                                                leadStatuses: state.leadStatus,
                                                phone_number: state.leads[index].contact != null ? state.leads[index].contact!.phone_number : "",
                                              ),
                                            ),
                                          );
                                          _canBuildLead = true;
                                        },
                                        child: MainLeadCard(
                                          title: state.leads[index].project!.name,
                                          last: state.leads[index].project!.description,
                                          date: state.leads[index].startDate,
                                          leadColor: AppColors.mainColor,
                                          price: 890,
                                          client1: '',
                                          client2: '',
                                        ),
                                      ),
                                    );
                                  });
                            } else if (state is HomeInitState && state.leads.isEmpty) {
                              return Center(
                                child: LocaleText(
                                  'empty',
                                  style: AppTextStyles.mainGrey,
                                ),
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.mainColor,
                                ),
                              );
                            }
                          },
                        ),
                        BlocBuilder<TasksBloc, TasksState>(
                          buildWhen: (context, state) => _canBuild,
                          builder: (context, state) {
                            if(state is TasksInitState && state.tasks.isNotEmpty) {

                              List<TasksModel> tasks = state.tasks.where((element) => element.name.toLowerCase().contains(search.toLowerCase())).toList();

                              return GridViewTasks(
                                tasks: tasks,
                                isSearch: true,
                                onTap: () async {
                                  _canBuild = false;

                                  await Navigator.push(context, MaterialPageRoute(builder: (context) => TaskPage(
                                    task: tasks.first,
                                    taskStatuses: state.tasksStatuses,
                                  )));

                                  _canBuild = true;
                                },
                              );
                            }else {
                              return SizedBox.shrink();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
