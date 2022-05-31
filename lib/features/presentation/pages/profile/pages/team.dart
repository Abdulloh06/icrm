/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:icrm/core/util/colors.dart';
import 'package:icrm/features/presentation/blocs/team_bloc/team_bloc.dart';
import 'package:icrm/features/presentation/blocs/team_bloc/team_event.dart';
import 'package:icrm/features/presentation/blocs/team_bloc/team_state.dart';
import 'package:icrm/features/presentation/pages/profile/components/add_team_dialog.dart';
import 'package:icrm/features/presentation/pages/profile/components/team_list.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:icrm/widgets/main_app_bar.dart';
import 'package:icrm/widgets/main_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icrm/widgets/main_tab_bar.dart';

class MyTeam extends StatelessWidget {
  MyTeam({Key? key}) : super(key: key);

  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 52),
          child: AppBarBack(
            title: 'team',
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
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: MainTabBar(
                      tabs: [
                        Tab(text: Locales.string(context, "all")),
                        Tab(text: Locales.string(context, 'seldom')),
                        Tab(text: Locales.string(context, 'often')),
                      ],
                    ),
                  ),
                  Expanded(
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20).copyWith(top: 0) ,
                              child: MainSearchBar(
                                onComplete: () => FocusScope.of(context).unfocus(),
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20).copyWith(top: 0),
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AddTeamDialog();
                                    },
                                  );
                                },
                                child: Container(
                                  width: 90,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          LocaleText(
                                            'add',
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 10),
                                          ),
                                          SvgPicture.asset(
                                            'assets/icons_svg/add_small.svg',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: BlocBuilder<TeamBloc, TeamState>(
                                builder: (context, state) {
                                  if (state is TeamInitState) {
                                    return TabBarView(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: TeamList(
                                            id: 1,
                                            team: state.team,
                                            search: _searchController.text,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: TeamList(
                                            id: 2,
                                            team: state.team,
                                            search: _searchController.text,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: TeamList(
                                            id: 3,
                                            team: state.team,
                                            search: _searchController.text,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    context.read<TeamBloc>().add(TeamInitEvent());
                                    return Loading();
                                  }
                                },
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
        ),
      ),
    );
  }
}
